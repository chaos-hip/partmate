package routes

import (
	"net/http"

	"git.chaos-hip.de/RepairCafe/PartMATE/errors"
	"github.com/gin-gonic/gin"
)

// Default404Handler is a gin handler function that returns a JSON error for 404 pages
func Default404Handler(c *gin.Context) {
	c.AbortWithStatusJSON(http.StatusNotFound, errors.NewResponse(
		"ENDPOINT_NOT_FOUND",
		"This is not the endpoint you are searching for",
		nil,
	))
}
