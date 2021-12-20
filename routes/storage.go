package routes

import (
	"net/http"

	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/errors"
	"git.chaos-hip.de/RepairCafe/PartMATE/models"
	"github.com/gin-gonic/gin"
)

func MakeStorageSearchHandler(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var search models.Search
		if err := c.BindJSON(&search); err != nil {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "Illegal storage location search request", err),
			)
			return
		}
		res, err := dbInstance.SearchStorageLocations(search)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to search for storage locations", err),
			)
			return
		}
		dtos := []models.StorageLocationDTO{}
		for _, loc := range res {
			dtos = append(dtos, *loc.ToDTO())
		}
		c.JSON(http.StatusOK, dtos)
	}
}
