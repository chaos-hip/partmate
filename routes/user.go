package routes

import (
	"crypto/rsa"
	"fmt"
	"net/http"
	"strings"
	"time"

	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/errors"
	"git.chaos-hip.de/RepairCafe/PartMATE/models"
	"git.chaos-hip.de/RepairCafe/PartMATE/models/permission"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v4"
	"github.com/lithammer/shortuuid/v3"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cast"
)

// MakeUserCreateHandler creates the handler for the "NewUser" endpoint
func MakeUserCreateHandler(db db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var user models.UserDTO
		if err := c.BindJSON(&user); err != nil {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "Illegal user request", err),
			)
			return
		}
		if err := user.Validate(); err != nil {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeValidationFailed, "User data is invalid", err),
			)
			return
		}
		dbModel, err := user.ToUser()
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeIllegalData, "Failed to map user into database model", err),
			)
			return
		}
		if err := db.CreateUser(*dbModel); err != nil {
			if strings.Contains(err.Error(), "Duplicate entry") {
				c.AbortWithStatusJSON(
					http.StatusConflict,
					errors.NewResponse(
						errors.TypeConflict,
						fmt.Sprintf("A user with the name %#v already exists", dbModel.Username),
						err,
					),
				)
				return
			}
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to create new user", err),
			)
			return
		}
		c.Status(http.StatusCreated)
	}
}

// loginRequest represents the JSON sent during login
type loginRequest struct {
	Username string `json:"user"`
	Password string `json:"password"`
}

// Validate checks the incoming request and returns an error if something is wrong
func (l *loginRequest) Validate() error {
	if strings.TrimSpace(l.Username) == "" {
		return fmt.Errorf("username is empty")
	}
	if l.Password == "" {
		return fmt.Errorf("password is empty")
	}
	return nil
}

// MakeLoginHandler returns a handler function used for the login API endpoint
func MakeLoginHandler(db db.DB, privateKey *rsa.PrivateKey, issuer string) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req loginRequest
		if err := c.BindJSON(&req); err != nil {
			logrus.WithError(err).Error("Failed to decode JSON input")
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "Invalid login request", err),
			)
			return
		}
		if err := req.Validate(); err != nil {
			logrus.WithError(err).Info("Login request validation failed")
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "Invalid login request payload", err),
			)
			return
		}
		user, err := db.GetUserByName(strings.TrimSpace(req.Username))
		if err != nil {
			logrus.WithError(err).Error("Failed to load user information")
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to load user data", nil), // Do not leak DB errors here!
			)
			return
		}
		if user == nil {
			logrus.Infof("User %#v does not exist", req.Username)
			c.AbortWithStatusJSON(
				http.StatusForbidden,
				errors.NewResponse(errors.TypeForbidden, "User does not exist", nil),
			)
			return
		}
		if !user.CheckPassword(req.Password) {
			logrus.Infof("Wrong password for user %#v", req.Username)
			c.AbortWithStatusJSON(
				http.StatusForbidden,
				errors.NewResponse(errors.TypeForbidden, "Wrong password", nil),
			)
			return
		}
		// All fine - we can assume the user to be logged in. Create a JWT and send it back
		jwt, err := createJWT(*user, privateKey, issuer, time.Now().Add(time.Hour))
		if err != nil {
			logrus.WithError(err).Error("Failed to create JWT")
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to create token", err),
			)
			return
		}
		c.JSON(http.StatusOK, gin.H{
			"token": jwt,
		})
	}
}

func createJWT(user models.User, privateKey *rsa.PrivateKey, issuer string, expiresAt time.Time) (string, error) {
	// All fine - we can assume the user to be logged in. Create a JWT and send it back
	claims := models.PermissionClaims{
		RegisteredClaims: jwt.RegisteredClaims{
			Issuer:    issuer,
			Subject:   user.Username,
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			ExpiresAt: jwt.NewNumericDate(expiresAt),
		},
		Permissions: user.Permissions(),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodRS512, &claims)
	return token.SignedString(privateKey)
}

func MakeTokenLoginHandler(db db.DB, privateKey *rsa.PrivateKey, issuer string) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := strings.TrimSpace(c.Param("id"))
		if id == "" {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeIllegalData, "No token passed", nil),
			)
			return
		}
		token, err := db.GetNonExpiredLoginTokenByID(id)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeIllegalData, "Failed to login by token", err),
			)
			return
		}
		if token == nil {
			logrus.Infof("No token exists for %#v", id)
			c.AbortWithStatusJSON(
				http.StatusForbidden,
				errors.NewResponse(errors.TypeForbidden, "Sorry, you do not have access to this API", nil),
			)
			return
		}
		// Load the associated user
		user, err := db.GetUserByName(token.Username)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeIllegalData, "Failed to get user information", err),
			)
			return
		}
		if user == nil {
			// Normally this won't happen because the tables are linked by FK, but in the case of a race condition...
			c.AbortWithStatusJSON(
				http.StatusForbidden,
				errors.NewResponse(errors.TypeIllegalData, "The user for this token does no longer exist", err),
			)
			return
		}
		// All fine - we can assume the user to be logged in. Create a JWT and send it back
		jwt, err := createJWT(
			*user,
			privateKey,
			issuer,
			time.Now().Add(time.Duration(token.SessionLengthSeconds)*time.Second),
		)
		if err != nil {
			logrus.WithError(err).Error("Failed to create JWT")
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to create token", err),
			)
			return
		}
		c.JSON(http.StatusOK, gin.H{
			"token": jwt,
		})
	}
}

// MakeUserGetCurrentHandler returns a handler function to drive the "GetMyUser" endpoint
func MakeUserGetCurrentHandler(db db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {

	}
}

func MakeUserSetPermissionsHandler(db db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		permissions := []string{}
		if err := c.BindJSON(&permissions); err != nil {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "Illegal permission list", err),
			)
			return
		}
		user := models.UserDTO{
			Username:    strings.TrimSpace(c.Param("name")), // Username is from the path
			Permissions: permissions,
		}
		if err := user.ValidatePermissions(); err != nil {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeValidationFailed, "Permission list is invalid", err),
			)
			return
		}
		// check if the user exists
		if u, err := db.GetUserByName(user.Username); err != nil || u == nil {
			if err != nil {
				c.AbortWithStatusJSON(
					http.StatusBadRequest,
					errors.NewResponse(errors.TypeValidationFailed, "Failed to read user data", err),
				)
				return
			}
			c.AbortWithStatusJSON(
				http.StatusNotFound,
				errors.NewResponse(errors.TypeValidationFailed, "User does not exist", err),
			)
			return
		}

		dbModel, err := user.ToUser()
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeIllegalData, "Failed to map user into database model", err),
			)
			return
		}
		logrus.Infof("Setting new user permissions for user %#v: %#v", dbModel.Username, dbModel.Permissions())
		if err := db.SetUserPermissions(*dbModel); err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to update user permissions", err),
			)
			return
		}
		c.Status(http.StatusNoContent)
	}
}

func MakeGetAvailablePermissions() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.JSON(http.StatusOK, permission.AvailablePermissions())
	}
}

func MakeLoginTokenRedirector(defaultBaseURL string) gin.HandlerFunc {
	return func(c *gin.Context) {
		var baseURL = defaultBaseURL
		if baseURL == "" {
			baseURL = getBaseURLFromRequest(c)
		}
		id := strings.TrimSpace(c.Param("id"))
		if id == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No token passed", nil),
			)
			return
		}
		c.Redirect(http.StatusTemporaryRedirect, fmt.Sprintf("%s/ui/token/%s", baseURL, id))
	}
}

func MakeCreateUserLoginTokenHandler(db db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var dto models.LoginTokenDTO
		if err := c.BindJSON(&dto); err != nil {
			logrus.WithError(err).Error("Failed to decode JSON input")
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "Invalid token creation request", err),
			)
			return
		}
		// Read the username from the path
		dto.Username = strings.TrimSpace(c.Param("name"))
		if dto.Username == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No username given", nil),
			)
			return
		}
		// Check if the user exists
		if user, err := db.GetUserByName(dto.Username); err != nil || user == nil {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "User could not be retrieved. Check if the user exists", err),
			)
			return
		}
		token := dto.ToLoginToken()
		if token.ExpiresAt.Valid && time.Now().After(token.ExpiresAt.Time) {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "Token expiry is in the past", nil),
			)
			return
		}
		// At least 60 seconds of session length
		if token.SessionLengthSeconds < 60 {
			token.SessionLengthSeconds = 60
		}
		// Generate our token by default
		token.Token = shortuuid.New()
		if err := db.CreateLoginToken(token); err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to create login token", err),
			)
			return
		}
		c.JSON(http.StatusOK, token.ToDTO())
	}
}

func MakeListUserLoginTokensHandler(db db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		// Read the username from the path
		username := strings.TrimSpace(c.Param("name"))
		if username == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No username given", nil),
			)
			return
		}
		includeExpired := cast.ToBool(c.Query("expired"))
		list, err := db.ListLoginTokensForUser(username, includeExpired)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to load tokens for user", err),
			)
			return
		}
		out := []models.LoginTokenDTO{}
		for _, item := range list {
			out = append(out, item.ToDTO())
		}
		c.JSON(http.StatusOK, out)
	}
}
