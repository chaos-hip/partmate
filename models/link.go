package models

//Link contains the URL for part-lookup (Table: mate_links)
type Link struct {
	PartID  string `json:"partID" db:"partID"`
	PartURL string `json:"link" db:"link"`
}
