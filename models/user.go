package models

// User is the Struct to identify the User (Table: mate_users)
type User struct {
	UserID      string `json:"-" db:"id"`
	Username    string `json:"name" db:"name"`
	Password    string `json:"-" db:"password_hash"` // Swordfish
	Permissions string `json:"permissions" db:"permissions"`
}
