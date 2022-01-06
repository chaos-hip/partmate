package routes

import (
	"net/http"
	"strings"

	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/errors"
	"git.chaos-hip.de/RepairCafe/PartMATE/models"
	"github.com/gin-gonic/gin"
	"github.com/spf13/cast"
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

func MakeGetStorageByLinkHandler(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := strings.TrimSpace(c.Param("id"))
		if id == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No storage ID passed", nil),
			)
			return
		}
		res, err := dbInstance.GetStorageLocationByLink(id)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to load storage location", err),
			)
			return
		}
		if res == nil {
			c.AbortWithStatusJSON(
				http.StatusNotFound,
				errors.NewResponse(errors.TypeNotFound, "The storage location with the given ID does not exist", nil),
			)
			return
		}
		c.JSON(http.StatusOK, res.ToDTO())
	}
}

func MakeGetPartsByStorageLocationLink(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var search models.Search
		id := strings.TrimSpace(c.Param("id"))
		if id == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No storage ID passed", nil),
			)
			return
		}
		search.StorageLocationLink = id
		if strVal, ok := c.GetQuery("limit"); ok {
			search.Limit = cast.ToUint(strVal)
		}
		if strVal, ok := c.GetQuery("offset"); ok {
			search.Offset = cast.ToUint(strVal)
		}

		res, err := dbInstance.SearchParts(search)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to list contents of storage location", err),
			)
			return
		}
		dtos := []models.PartDTO{}
		for _, p := range res {
			dto := p.ToDTO()
			dto.Storage = nil
			dtos = append(dtos, dto)
		}
		c.JSON(http.StatusOK, dtos)
	}
}
