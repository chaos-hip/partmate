package models

import "database/sql"

// StorageLocation represents a single storage location for parts
type StorageLocation struct {
	ID        int            `db:"id"`
	Link      sql.NullString `db:"link"`
	Name      string         `db:"name"`
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
		Name: s.Name,
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
	Link      string `json:"id"`
	Name      string `json:"name"`
	ImageLink string `json:"image,omitempty"`
}
