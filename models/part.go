package models

type Part struct {
	Name        string   `json:"name" db:"name"`
	Description string   `json:"description" db:"description"`
	Comment     string   `json:"comment" db:"comment"`
	Category    Category `json:"category"`
}

type Category struct {
	InternalID       int    `db:"id" json:"-"`
	InternalParentID int    `db:"parent_id" json:"-"`
	Name             string `json:"name" db:"name"`
	Path             string `json:"path" db:"path"`
}
