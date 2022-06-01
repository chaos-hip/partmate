package routes

import (
	"net/http"
	"path/filepath"
	"strings"

	"github.com/chaos-hip/partmate/errors"
	"github.com/gin-gonic/gin"
)

// Default404Handler is a gin handler function that returns a JSON error for 404 pages
func Default404Handler(c *gin.Context) {
	if strings.HasPrefix(c.FullPath(), "/ui/") {
		// Just deliver the index.html page
		c.File(filepath.Join(".", "public", "index.html"))
		return
	}
	c.AbortWithStatusJSON(http.StatusNotFound, errors.NewResponse(
		"ENDPOINT_NOT_FOUND",
		"This is not the endpoint you are searching for",
		nil,
	))
}
