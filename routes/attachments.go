package routes

import (
	errs "errors"
	"fmt"
	_ "image/gif"
	"image/jpeg"
	"image/png"
	"net/http"
	"strings"

	"io/fs"
	"os"

	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/errors"
	"git.chaos-hip.de/RepairCafe/PartMATE/models"
	"github.com/disintegration/imaging"
	"github.com/gin-gonic/gin"
)

const (
	thumbnailSize = 512
)

func createThumbnail(att models.PartAttachment) error {
	originalImage, err := imaging.Open(att.StorageLocation(), imaging.AutoOrientation(true))
	if err != nil {
		return fmt.Errorf("failed to load original image: %w", err)
	}
	thumbnail := imaging.Fill(originalImage, thumbnailSize, thumbnailSize, imaging.Center, imaging.Lanczos)
	outFile, err := os.Create(att.ThumbnailLocation())
	if err != nil {
		return fmt.Errorf("failed to create thumbnail file: %w", err)
	}
	defer outFile.Close()
	switch att.MimeType {
	case "image/png":
		err = png.Encode(outFile, thumbnail)
	default:
		// Let's create a JPEG
		err = jpeg.Encode(outFile, thumbnail, &jpeg.Options{Quality: 90})
	}
	if err != nil {
		return fmt.Errorf("failed to write thumbnail image: %w", err)
	}
	return nil
}

func createThumbIfMissing(att models.PartAttachment) error {
	if !att.IsImageFile() {
		return fmt.Errorf("the attachment is not an image file")
	}
	fInfo, err := os.Stat(att.ThumbnailLocation())
	if err != nil && !errs.Is(err, fs.ErrNotExist) {
		return fmt.Errorf("failed to check for thumbnail existence: %w", err)
	}
	if err == nil && fInfo.IsDir() {
		return fmt.Errorf("thumbnail is not a file, but a directory")
	}
	if err != nil {
		// Only error left is "file not found" - create the thumbnail
		return createThumbnail(att)
	}
	return nil
}

func MakeGetThumbnailImageHandler(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		link := strings.TrimSpace(c.Params.ByName("id"))
		if link == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No attachment ID provided", nil),
			)
			return
		}
		att, err := dbInstance.GetAttachmentEntry(link)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to read image information", err),
			)
			return
		}
		if att == nil {
			c.AbortWithStatusJSON(
				http.StatusNotFound,
				errors.NewResponse(errors.TypeNotFound, "The requested image does not exist", nil),
			)
			return
		}
		createThumbIfMissing(*att)
		c.File(att.ThumbnailLocation())
	}
}

func MakePartAttachmentDownloadHandler(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		link := strings.TrimSpace(c.Params.ByName("id"))
		if link == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No attachment ID provided", nil),
			)
			return
		}
		att, err := dbInstance.GetAttachmentEntry(link)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to read attachment information", err),
			)
			return
		}
		if att == nil {
			c.AbortWithStatusJSON(
				http.StatusNotFound,
				errors.NewResponse(errors.TypeNotFound, "This is not the attachment you are searching for", nil),
			)
			return
		}
		c.FileAttachment(att.StorageLocation(), att.OriginalName)
	}
}

func MakePartAttachmentListHandler(dbInstance db.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		partLink := strings.TrimSpace(c.Param("id"))
		if partLink == "" {
			c.AbortWithStatusJSON(
				http.StatusBadRequest,
				errors.NewResponse(errors.TypeIllegalData, "No part ID provided", nil),
			)
			return
		}
		attList, err := dbInstance.GetAttachmentsByPartLink(partLink)
		if err != nil {
			c.AbortWithStatusJSON(
				http.StatusInternalServerError,
				errors.NewResponse(errors.TypeDBError, "Failed to read attachment list", err),
			)
			return
		}
		out := []models.PartAttachmentDTO{}
		for _, att := range attList {
			out = append(out, att.ToDTO())
		}
		c.JSON(http.StatusOK, out)
	}
}
