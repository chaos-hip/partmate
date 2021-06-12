package routes

import (
	"fmt"
	"net/http"
	"strings"

	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/errors"
	"git.chaos-hip.de/RepairCafe/PartMATE/models"
	"github.com/gin-gonic/gin"
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
