package auth

import (
	"crypto/rsa"
	"fmt"
	"net/http"
	"strings"

	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/errors"
	"git.chaos-hip.de/RepairCafe/PartMATE/models"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

const (
	contextKey    = "partmate::user"
	authHeaderKey = "Authorization"
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

func returnAccessDenied(c *gin.Context, details string) {
	if strings.HasPrefix(c.Request.URL.Path, "/api") {
		// Return a JSON-based error
		res := &errors.ErrorResponse{
			Type:    errors.TypeForbidden,
			Message: "Not authenticated. You have to log-in to use this API",
		}
		if details != "" {
			res.Details = gin.H{
				"error": details,
			}
		}
		c.JSON(http.StatusForbidden, res)
	} else {
		// Return HTML
		c.HTML(http.StatusForbidden, "access-denied.tmpl", gin.H{
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
			returnAccessDenied(c, "No token sent with request")
			return
		}
		// Try to decode the JWT
		parsedToken, err := jwt.ParseWithClaims(token, &jwt.StandardClaims{}, func(t *jwt.Token) (interface{}, error) {
			return pubkey, nil
		})
		if err != nil {
			logrus.WithError(err).Error("Illegal token presented by user request")
			returnAccessDenied(c, err.Error())
			return
		}
		// JWT is valid - load the user from the DB
		claims := parsedToken.Claims.(*jwt.StandardClaims)
		user, err := repo.GetUserByName(claims.Subject)
		if err != nil {
			logrus.WithError(err).Errorf("Failed to retrieve user by name %#v", claims.Subject)
			returnAccessDenied(c, fmt.Sprintf("Cannot read user information: %s", err.Error()))
			return
		}
		if user == nil {
			logrus.Errorf("Cannot use authenticated token: User %#v does not exist", claims.Subject)
			returnAccessDenied(c, fmt.Sprintf("Sorry, your user %#v does not exist in the database", claims.Subject))
			return
		}
		userToContext(c, user)
	}
}
