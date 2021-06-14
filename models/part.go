package models

import "database/sql"

// Part represents the Struct for Part/Item Queries
type Part struct {
	ID            int            `db:"id"`
	Link          sql.NullString `db:"link"`
	Name          string         `db:"name"`
	Description   string         `db:"description"`
	Comment       string         `db:"comment"`
	CategoryID    int            `db:"category_id"`
	Condition     string         `db:"partCondition"`
	StockLevel    int            `db:"stockLevel"`
	MinStockLevel int            `db:"minStockLevel"`
	Status        string         `db:"status"`
	NeedsReview   bool           `db:"needsReview"`
	LowStock      bool           `db:"lowStock"`
}

// ToDTO converts the part into its DTO counterpart
func (p *Part) ToDTO() PartDTO {
	out := PartDTO{
		Name:          p.Name,
		Description:   p.Description,
		Comment:       p.Comment,
		CategoryID:    p.CategoryID,
		Condition:     p.Condition,
		StockLevel:    p.StockLevel,
		MinStockLevel: p.MinStockLevel,
		Status:        p.Status,
		NeedsReview:   p.NeedsReview,
		LowStock:      p.LowStock,
	}
	if p.Link.Valid {
		out.Link = p.Link.String
	}
	return out
}

// PartDTO is the data transfer object for the Part database model
type PartDTO struct {
	Link          string `json:"id"` // The link (external ID) of the part
	Name          string `json:"name"`
	Description   string `json:"description"`
	Comment       string `json:"comment"`
	CategoryID    int    `json:"categoryId"`
	Condition     string `json:"condition"`
	StockLevel    int    `json:"stockLevel"`
	MinStockLevel int    `json:"minStockLevel"`
	Status        string `json:"status"`
	NeedsReview   bool   `json:"needsReview"`
	LowStock      bool   `json:"lowStock"`
}
