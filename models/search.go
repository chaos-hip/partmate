package models

type PaginationInfo struct {
	Offset         uint `json:"offset"`
	Limit          uint `json:"limit"`
	IgnoreMaxLimit bool `json:"-"` // Optional switch the a requesting function can set to disable the upper limit
}

type Search struct {
	PaginationInfo
	Term                string `json:"term"`
	StorageLocationLink string `json:"storage"`
}
