package models

type PaginationInfo struct {
	Offset uint `json:"offset"`
	Limit  uint `json:"limit"`
}

type Search struct {
	PaginationInfo
	Term                string `json:"term"`
	StorageLocationLink string `json:"storage"`
}
