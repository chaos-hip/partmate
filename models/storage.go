package models

import (
	"database/sql"
	"strings"
)

// A StorageCategory describes the category a storage location is located in
type StorageCategory struct {
	ID          int            `db:"category_id"`
	Link        sql.NullString `db:"category_link"`
	Name        string         `db:"category_name"`
	Description string         `db:"category_description"`
	Path        string         `db:"category_path"`
}

// normalizePath returns the parent path of the current category with the root level removed
func (c *StorageCategory) normalizePath() string {
	parts := strings.Split(c.Path, " ➤ ")[1:]
	if len(parts) == 1 {
		return "/"
	}
	parts = parts[:len(parts)-2]
	return "/" + strings.Join(parts, "/")
}

// ToDTO converts the storage category into its DTO
func (c *StorageCategory) ToDTO() *StorageCategoryDTO {
	return &StorageCategoryDTO{
		Name:        c.Name,
		Description: c.Description,
		Path:        c.normalizePath(),
	}
}

// StorageLocation represents a single storage location for parts
type StorageLocation struct {
	ID   int            `db:"id"`
	Link sql.NullString `db:"link"`
	Name string         `db:"name"`
	StorageCategory
	ImageID   sql.NullInt64  `db:"image_id"`   // Internal ID of the attachment used as image for this location
	ImageLink sql.NullString `db:"image_link"` // Link pointing to the image used for this location
}

// ToDTO converts the storage location to its DTO representation
//
// A pointer is returned in this case since a storage location may be nil
func (s *StorageLocation) ToDTO() *StorageLocationDTO {
	if s == nil {
		return nil
	}
	out := StorageLocationDTO{
		Name:     s.Name,
		Category: *s.StorageCategory.ToDTO(),
	}
	if s.Link.Valid {
		out.Link = s.Link.String
	}
	if s.ImageLink.Valid {
		out.ImageLink = s.ImageLink.String
	}
	return &out
}

// StorageLocationDTO is the data transfer object for a storage location
type StorageLocationDTO struct {
	Link      string             `json:"id"`
	Name      string             `json:"name"`
	ImageLink string             `json:"image,omitempty"`
	Category  StorageCategoryDTO `json:"category,omitempty"`
}

// StorageCategoryDTO is the data transfer object for a storage category
type StorageCategoryDTO struct {
	Name        string `json:"name"`
	Description string `json:"description,omitempty"`
	Path        string `json:"path,omitempty"`
}
