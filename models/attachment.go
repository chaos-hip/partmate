package models

import (
	"database/sql"
	"fmt"
	"path/filepath"
)

// PartAttachment is the Struct to identify and modify Attachment-Data
type PartAttachment struct {
	BaseDir      string       // Base directory where the attachments are stored
	InternalID   int          `db:"id"`
	PartID       int          `db:"part_id"`
	Type         string       `db:"type"`
	FileName     string       `db:"filename"`
	OriginalName string       `db:"originalname"`
	MimeType     string       `db:"mimetype"`
	Size         int          `db:"size"`
	Extension    string       `db:"extension"`
	Description  *string      `db:"description"`
	IsImage      sql.NullBool `db:"isImage"`
}

func (a *PartAttachment) GetExtension() string {
	if a.Extension != "" {
		return a.Extension
	}
	switch a.MimeType {
	case "application/pdf":
		return "pdf"
	case "image/png":
		return "png"
	default:
		return "jpeg"
	}
}

func (a *PartAttachment) StorageLocation() string {
	return filepath.Join(
		a.BaseDir,
		"files",
		a.Type,
		fmt.Sprintf("%s.%s", a.FileName, a.GetExtension()),
	)
}

func (a *PartAttachment) ThumbnailLocation() string {
	return filepath.Join(
		a.BaseDir,
		"thumb",
		a.Type,
		fmt.Sprintf("%s.%s", a.FileName, a.GetExtension()),
	)
}

func (a *PartAttachment) IsImageFile() bool {
	switch a.MimeType {
	case "image/jpeg", "image/png":
		return true
	default:
		return false
	}
}
