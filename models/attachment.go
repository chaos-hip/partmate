package models

type Attachment struct {
	InternalID int    `json:"-" db:"id"`
	PartId     int    `json:"partid" db:"part_id"`
	FileName   string `json:"filename" db:"filename"`
	MimeType   string `json:"mimetype" db:"mimetype"`
	Size       int    `json:"size" db:"size"`
	IsImage    *bool  `json:"isimage" db:"isimage"`
}
