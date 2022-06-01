package routes

import (
	"fmt"
	"image/png"
	"net/http"
	"strings"

	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/errors"
	"git.chaos-hip.de/RepairCafe/PartMATE/models"
	"github.com/boombuler/barcode"
	"github.com/boombuler/barcode/qr"
	"github.com/gin-gonic/gin"
	"github.com/lithammer/shortuuid/v3"
	"github.com/spf13/cast"
)

var (
	// Temporary token storage for downloading the content report for a specific storage location
	// Key is the token, value the ID of the storage location
	contentReportDownloadTokens = map[string]string{}
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

func MakeStorageContentReport(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := strings.TrimSpace(c.Param("id"))
		if id == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No storage ID passed", nil),
			)
			return
		}
		loc, err := dbInstance.GetStorageLocationByLink(id)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to get storage location info", err),
			)
			return
		}
		if loc == nil {
			c.AbortWithStatusJSON(
				http.StatusNotFound,
				errors.NewResponse(errors.TypeDBError, "No storage location exists with this ID", err),
			)
			return
		}
		token := shortuuid.New()
		contentReportDownloadTokens[token] = id
		c.JSON(http.StatusOK, token)
	}

}

func MakeStorageContentReportByToken(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var search models.Search
		token := strings.TrimSpace(c.Param("token"))
		if token == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No download token passed", nil),
			)
			return
		}
		id, ok := contentReportDownloadTokens[token]
		if !ok {
			c.AbortWithStatusJSON(
				http.StatusNotFound,
				errors.NewResponse(
					errors.TypeIllegalData,
					"This download link expired. Please re-request the report from within the web app",
					nil,
				),
			)
			return
		}
		// Download is one-time only
		delete(contentReportDownloadTokens, token)
		search.StorageLocationLink = id
		search.IgnoreMaxLimit = true
		search.Limit = 100000

		// Read the storage location info itself
		loc, err := dbInstance.GetStorageLocationByLink(id)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to get storage location info", err),
			)
			return
		}
		if loc == nil {
			c.AbortWithStatusJSON(
				http.StatusNotFound,
				errors.NewResponse(errors.TypeNotFound, "No storage location exists with this ID", err),
			)
			return
		}

		parts, err := dbInstance.SearchParts(search)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to get list of contents for the storage location", err),
			)
			return
		}
		c.HTML(http.StatusOK, "storage-contents.tmpl", gin.H{
			"Storage": loc,
			"Parts":   parts,
		})
	}

}

func MakeGetStorageQRCodeHandler(dbInstance db.DB, defaultBaseURL string) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := strings.TrimSpace(c.Param("id"))
		if id == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No storage ID provided", nil),
			)
			return
		}
		loc, err := dbInstance.GetStorageLocationByLink(id)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to fetch storage location", err),
			)
			return
		}
		if loc == nil {
			c.AbortWithStatusJSON(
				http.StatusNotFound,
				errors.NewResponse(errors.TypeNotFound, "This is not the endpoint you are looking for, bro", nil),
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
