package models

// User is the Struct to identify the User (Requests and Cretentials)
type User struct {
	UserID   string `json:"-" db:"id"`
	Username string `json:"username" db:"username"`
	Enabled  *bool  `json:"enabled" db:"enabled"`
	Password string `json:"-" db:"password"` // Swordfish
	Salt     string `json:"-" db:"salt"`
	Locked   *bool  `json:"locked" db:"locked"`
}
