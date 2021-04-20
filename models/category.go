package models

// Category is the representation of a PartKeeper category
type Category struct {
	InternalID       int    `db:"id" json:"-"`
	InternalParentID int    `db:"parent_id" json:"-"`
	Name             string `json:"name" db:"name"`
	Path             string `json:"path" db:"path"`
}
