package auth

import (
	"crypto/rsa"
	"fmt"
	"net/http"
	"strings"

	"github.com/chaos-hip/partmate/db"
	"github.com/chaos-hip/partmate/errors"
	"github.com/chaos-hip/partmate/models"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v4"
	"github.com/sirupsen/logrus"
)

const (
	contextKey    = "partmate::user"
	authHeaderKey = "Authorization"

	errNoPermission = "Sorry, you do not have the permissions needed to use this API endpoint"
)

func userToContext(c *gin.Context, u *models.User) {
	c.Set(contextKey, u)
}

// UserFromContext reads the HTTP request's user from the gin context
func UserFromContext(c *gin.Context) *models.User {
	data, ok := c.Get(contextKey)
	if ok {
		if u, ok := data.(*models.User); ok {
			return u
		}
	}
	return nil

}

func returnAccessDenied(c *gin.Context, details string, lackingPermissions bool) {
	status := http.StatusForbidden
	if !lackingPermissions {
		status = http.StatusUnauthorized
		c.Header("WWW-Authenticate", `Bearer realm="api" scope="partMATE"`)
	}
	if strings.HasPrefix(c.Request.URL.Path, "/api") {
		// Return a JSON-based error
		res := &errors.ErrorResponse{
			Type:    errors.TypeForbidden,
			Message: "Access denied",
		}
		if lackingPermissions {
			res.Type = errors.TypeInsufficientPermissions
		}
		if details != "" {
			res.Details = gin.H{
				"error": details,
			}
		}
		c.JSON(status, res)
	} else {
		// Return HTML
		c.HTML(status, "access-denied.tmpl", gin.H{
			"error": details,
		})
	}
	c.AbortWithStatus(http.StatusForbidden)
}

// MakeAuthMiddleware creates a middleware that checks the incoming request for the token cookie
// If no token cookie is set or the token does not exist in the user DB, an access denied page is displayed to the user
func MakeAuthMiddleware(repo db.DB, pubkey *rsa.PublicKey) gin.HandlerFunc {
	return func(c *gin.Context) {
		token := strings.TrimPrefix(c.GetHeader(authHeaderKey), "Bearer ")
		if token == "" {
			returnAccessDenied(c, "No token sent with request", false)
			return
		}
		// Try to decode the JWT
		parsedToken, err := jwt.ParseWithClaims(token, &jwt.RegisteredClaims{}, func(t *jwt.Token) (interface{}, error) {
			return pubkey, nil
		})
		if err != nil {
			logrus.WithError(err).Error("Illegal token presented by user request")
			returnAccessDenied(c, err.Error(), false)
			return
		}
		// JWT is valid - load the user from the DB
		claims := parsedToken.Claims.(*jwt.RegisteredClaims)
		user, err := repo.GetUserByName(claims.Subject)
		if err != nil {
			logrus.WithError(err).Errorf("Failed to retrieve user by name %#v", claims.Subject)
			returnAccessDenied(c, fmt.Sprintf("Cannot read user information: %s", err.Error()), false)
			return
		}
		if user == nil {
			logrus.Errorf("Cannot use authenticated token: User %#v does not exist", claims.Subject)
			returnAccessDenied(
				c,
				fmt.Sprintf("Sorry, your user %#v does not exist in the database", claims.Subject),
				false,
			)
			return
		}
		userToContext(c, user)
	}
}

// MakePermissionMiddleware creates a middleware that will make sure that the incoming user has the given permissions
// before the request itself is handled. If the user does not have the correct permission, a HTTP 403 error is returned
func MakePermissionMiddleware(permissions ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		user := UserFromContext(c)
		if user == nil {
			logrus.Errorf("No user present during permission check")
			returnAccessDenied(c, errNoPermission, true)
			return
		}
		if !user.Can(permissions...) {
			logrus.Errorf(
				"[%s %s] User %#v does not have access to this endpoint. Permissions required: %+v",
				c.Request.Method,
				c.FullPath(),
				user.Username,
				permissions,
			)
			returnAccessDenied(c, errNoPermission, true)
			return
		}
	}
}
