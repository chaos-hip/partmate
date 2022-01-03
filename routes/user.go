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
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v4"
	"github.com/sirupsen/logrus"
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
		claims := jwt.StandardClaims{
			Issuer:    issuer,
			Subject:   user.Username,
			IssuedAt:  time.Now().Unix(),
			ExpiresAt: time.Now().Add(time.Hour).Unix(),
		}
		token := jwt.NewWithClaims(jwt.SigningMethodRS512, &claims)
		jwt, err := token.SignedString(privateKey)
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
