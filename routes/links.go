package routes

import (
	"fmt"
	"net/http"
	"regexp"
	"strings"

	"github.com/chaos-hip/partmate/db"
	"github.com/chaos-hip/partmate/errors"
	"github.com/chaos-hip/partmate/models"
	"github.com/gin-gonic/gin"
)

var (
	regexIsValidLink = regexp.MustCompile(`^[a-zA-Z0-9_\.\-]{1,64}$`)
)

//-- Helpers -----------------------------------------------------------------------------------------------------------

func doCreateLink(c *gin.Context, dbInstance db.DB, input models.LinkDTO) {
	if err := input.Validate(); err != nil {
		c.AbortWithStatusJSON(
			http.StatusBadRequest,
			errors.NewResponse(errors.TypeIllegalData, "Invalid link request", err),
		)
		return
	}
	link, err := input.ToLink(dbInstance.GetLinkByID)
	if err != nil {
		c.AbortWithStatusJSON(
			http.StatusBadRequest,
			errors.NewResponse(errors.TypeIllegalData, "Target validation failed", err),
		)
		return
	}
	// API requests never create auto-generated links
	link.AutoGenerated = false
	outLink, err := dbInstance.CreateLink(*link)
	if err != nil {
		if strings.Contains(err.Error(), "Duplicate entry") {
			c.AbortWithStatusJSON(
				http.StatusConflict,
				errors.NewResponse(errors.TypeConflict, "A link with the given ID does already exist", nil),
			)
			return
		}
		c.AbortWithStatusJSON(
			http.StatusInternalServerError,
			errors.NewResponse(errors.TypeIllegalData, "Failed to create link", err),
		)
		return
	}
	c.JSON(http.StatusOK, outLink.ToDTO())
}

func getBaseURLFromRequest(c *gin.Context) string {
	proto := "http"
	if val := c.Request.Header.Get("X-Forwarded-Proto"); val != "" {
		proto = val
	}
	// ToDo: Secure this when not using a proxy in front
	if val := c.Request.Header.Get("X-Forwarded-Host"); val != "" {
		return fmt.Sprintf("%s://%s", proto, val)
	}
	return "" // This will force a relative URL
}

//-- Handlers ----------------------------------------------------------------------------------------------------------

func MakeLinkRedirectHandler(dbInstance db.DB, defaultBaseURL string) gin.HandlerFunc {
	return func(c *gin.Context) {
		var baseURL = defaultBaseURL
		if baseURL == "" {
			baseURL = getBaseURLFromRequest(c)
		}
		id := strings.TrimSpace(c.Param("id"))
		if id == "" || !regexIsValidLink.MatchString(id) {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No or illegal link ID passed", nil),
			)
			return
		}
		link, err := dbInstance.GetLinkByID(id)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Error fetching links", err),
			)
			return
		}
		fmt.Printf("%s/ui/part/%s\n", baseURL, id)
		if link == nil {
			// Redirect to link page
			c.Redirect(http.StatusTemporaryRedirect, fmt.Sprintf("%s/ui/link/%s", baseURL, id))
			return
		}

		switch link.GetTargetType() {
		case models.TargetTypePart:
			c.Redirect(http.StatusTemporaryRedirect, fmt.Sprintf("%s/ui/part/%s", baseURL, link.Link))
		case models.TargetTypeStorage:
			c.Redirect(http.StatusTemporaryRedirect, fmt.Sprintf("%s/ui/storage/%s", baseURL, link.Link))
		default:
			c.AbortWithStatusJSON(
				http.StatusNotImplemented,
				errors.NewResponse(errors.TypeIllegalData, "You provided a link to an unsupported target type", nil),
			)
		}
	}
}

// MakeLinkListHandler returns a handler function that lists the links belonging to an item that is linkable
// Linkable items are parts, storage locations and attachments
func MakeLinkListHandler(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := strings.TrimSpace(c.Param("id"))
		if id == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No link ID passed", nil),
			)
			return
		}
		links, err := dbInstance.GetLinksByLinkID(id)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Error fetching links", err),
			)
			return
		}
		out := []models.LinkDTO{}
		for _, l := range links {
			out = append(out, l.ToDTO())
		}
		c.JSON(http.StatusOK, out)
	}
}

// MakeGetLinkInfoHandler returns a handler that responds with information about the link passed-in
func MakeGetLinkInfoHandler(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := strings.TrimSpace(c.Param("id"))
		if id == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No link ID passed", nil),
			)
			return
		}
		link, err := dbInstance.GetLinkByID(id)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Error fetching link", err),
			)
			return
		}
		if link == nil {
			// Using it like this will automatically set the type to "unknown"
			link = &models.Link{
				Link: id,
			}
		}
		c.JSON(http.StatusOK, link.ToDTO())
	}
}

// MakeLinkCreateByPathHandler creates a handler function that does the same as MakeLinkCreateHandler, but with the
// parameters taken from the path
func MakeLinkCreateByPathHandler(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		input := models.LinkDTO{
			Link:       strings.TrimSpace(c.Param("linkID")),
			TargetType: models.TargetTypePart,
			Target:     strings.TrimSpace(c.Param("id")),
		}
		doCreateLink(c, dbInstance, input)
	}
}

// MakeLinkCreateHandler creates a handler function for the create link endpoint
func MakeLinkCreateHandler(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var input models.LinkDTO
		if err := c.BindJSON(&input); err != nil {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "Illegal link request", err),
			)
			return
		}
		doCreateLink(c, dbInstance, input)
	}
}

// MakeLinkDeleteHandler creates a handler function to use with the DeleteLink endpoint
func MakeLinkDeleteHandler(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		linkID := strings.TrimSpace(c.Param("id"))
		if linkID == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No link ID given", nil),
			)
			return
		}
		if err := dbInstance.DeleteLinkByID(linkID); err != nil {
			if err == db.ErrNothingDeleted {
				c.AbortWithStatusJSON(
					http.StatusNotFound,
					errors.NewResponse(errors.TypeNotFound, "The link with the given ID does not exist", nil),
				)
				return
			}
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to delete link", err),
			)
			return
		}
		c.Status(http.StatusNoContent)
	}
}
