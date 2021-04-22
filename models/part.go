package models

type Part struct {
	Name        string   `json:"name" db:"name"`
	Description string   `json:"description" db:"description"`
	Comment     string   `json:"comment" db:"comment"`
	Category    Category `json:"category"`
	StockLevel  string   `json:"stocklevel" db:"stockLevel"`
	Status      string   `json:"status" db:"status"`
	NeedsReview *bool    `json:"needsreview" db:"needsReview"`
	LowStock    *bool    `json:"lowstock" db:"lowStock"`
}
