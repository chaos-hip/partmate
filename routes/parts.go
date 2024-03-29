package routes

import (
	"fmt"
	"image/png"
	"net/http"
	"strings"

	"github.com/boombuler/barcode"
	"github.com/boombuler/barcode/qr"
	"github.com/chaos-hip/partmate/db"
	"github.com/chaos-hip/partmate/errors"
	"github.com/chaos-hip/partmate/models"
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

func MakeGetPartByLinkHandler(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := strings.TrimSpace(c.Param("id"))
		if id == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No part ID passed", nil),
			)
			return
		}
		res, err := dbInstance.GetPartByLink(id)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to load part", err),
			)
			return
		}
		if res == nil {
			c.AbortWithStatusJSON(
				http.StatusNotFound,
				errors.NewResponse(errors.TypeNotFound, "The part with the given ID does not exist", nil),
			)
			return
		}
		c.JSON(http.StatusOK, res.ToDTO())
	}
}

func MakeGetPartQRCodeHandler(dbInstance db.DB, defaultBaseURL string) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := strings.TrimSpace(c.Param("id"))
		if id == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No part ID provided", nil),
			)
			return
		}
		part, err := dbInstance.GetPartByLink(id)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to fetch part", err),
			)
			return
		}
		if part == nil {
			c.AbortWithStatusJSON(
				http.StatusNotFound,
				errors.NewResponse(errors.TypeNotFound, "This is not the endpoint you are looking for, sis", nil),
			)
			return
		}
		var baseURL = defaultBaseURL
		if baseURL == "" {
			baseURL = getBaseURLFromRequest(c)
		}
		url := fmt.Sprintf("%s/l/%s", baseURL, id)
		// Render the QR code
		code, err := qr.Encode(url, qr.M, qr.Auto)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to generate code", err),
			)
			return
		}
		code, err = barcode.Scale(code, 512, 512)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to scale code", err),
			)
			return
		}
		c.Writer.Header().Set("Content-Type", "image/png")
		png.Encode(c.Writer, code)
	}
}

type partMoveRequest struct {
	To string `json:"to"`
}

// MakeMovePartHandler creates a HTTP handler that moves a part from one storage location to another
func MakeMovePartHandler(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := strings.TrimSpace(c.Param("id"))
		if id == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No part ID provided", nil),
			)
			return
		}
		part, err := dbInstance.GetPartByLink(id)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to fetch part", err),
			)
			return
		}
		if part == nil {
			c.AbortWithStatusJSON(
				http.StatusNotFound,
				errors.NewResponse(errors.TypeNotFound, "Part not found", nil),
			)
			return
		}
		var req partMoveRequest
		if err := c.BindJSON(&req); err != nil {
			c.AbortWithStatusJSON(
				http.StatusNotFound,
				errors.NewResponse(errors.TypeIllegalData, "No target storage location provided", nil),
			)
			return
		}
		storage, err := dbInstance.GetStorageLocationByLink(req.To)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to fetch storage location", err),
			)
			return
		}
		if storage == nil {
			c.AbortWithStatusJSON(
				http.StatusNotFound,
				errors.NewResponse(errors.TypeNotFound, "Target storage location not found", nil),
			)
			return
		}
		// All checked - let's do the thing...
		if err := dbInstance.MovePart(part.ID, storage.ID); err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to move part to new storage location", err),
			)
			return
		}
		c.Status(http.StatusNoContent)
	}

}
