package routes

import (
	"net/http"

	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/errors"
	"git.chaos-hip.de/RepairCafe/PartMATE/models"
	"github.com/gin-gonic/gin"
)

// MakePartsSearchHandler creates the handler function needed for the parts search endpoint
func MakePartsSearchHandler(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var search models.Search
		if err := c.BindJSON(&search); err != nil {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "Illegal parts search request", err),
			)
			return
		}
		res, err := dbInstance.SearchParts(search)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to search for parts", err),
			)
			return
		}
		dtos := []models.PartDTO{}
		for _, p := range res {
			dtos = append(dtos, p.ToDTO())
		}
		c.JSON(http.StatusOK, dtos)
	}
}
