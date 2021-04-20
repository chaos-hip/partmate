package models

type Part struct {
	Name        string   `json:"name" db:"name"`
	Description string   `json:"description" db:"description"`
	Comment     string   `json:"comment" db:"comment"`
	Category    Category `json:"category"`
}
