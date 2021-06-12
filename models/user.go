package models

import (
	"encoding/json"
	"fmt"
	"strings"

	"git.chaos-hip.de/RepairCafe/PartMATE/auth"
	"github.com/sirupsen/logrus"
)

const (
	minPasswordLength = 8
)

// User is the Struct to identify the User (Table: mate_users)
type User struct {
	Username       string `db:"name"`
	PasswordHash   string `db:"password_hash"` // Swordfish
	RawPermissions string `db:"permissions"`
}

// CheckPassword takes a given password and checks if the password has matches that input
func (u *User) CheckPassword(input string) bool {
	hash, err := auth.HashFromString(u.PasswordHash)
	if err != nil {
		logrus.WithError(err).Error("Failed to decode password hash for user %#v: %w", u.Username, err)
	}
	return hash.Matches(input)
}

// ToDTO converts the user DB model to its DTO representation
func (u *User) ToDTO() UserDTO {
	perms := []string{}
	if err := json.Unmarshal([]byte(u.RawPermissions), &perms); err != nil {
		logrus.WithError(err).Errorf("Failed to decode permissions for user %#v", u.Username)
	}
	return UserDTO{
		Username:    u.Username,
		Permissions: perms,
	}
}

// UserDTO represents a user in the JSON API
type UserDTO struct {
	Username    string   `json:"name"`
	Password    string   `json:"password,omitempty"` // The password will only sent to the API when creating a user
	Permissions []string `json:"permissions"`
}

// ToUser tries to convert the DTO to the database user object - optionally also setting the password
func (u *UserDTO) ToUser() (*User, error) {
	out := &User{
		Username: strings.TrimSpace(strings.ToLower(u.Username)), // normalize to lower-case
	}
	if len(u.Permissions) == 0 {
		u.Permissions = []string{}
	}
	permData, err := json.Marshal(u.Permissions)
	if err != nil {
		return nil, fmt.Errorf("failed to marshal user permissions: %w", err)
	}
	out.RawPermissions = string(permData)
	if u.Password != "" {
		hash, err := auth.NewArgonHash(u.Password)
		if err != nil {
			return nil, fmt.Errorf("failed to create password hash for user: %w", err)
		}
		out.PasswordHash = hash.String()
	}
	return out, nil
}

// Validate checks if the data in the user DTO is valid and returns an error if not
func (u *UserDTO) Validate() error {
	if strings.TrimSpace(u.Username) == "" {
		return fmt.Errorf("username is empty")
	}
	if len(u.Password) < minPasswordLength {
		return fmt.Errorf("password too short: Please use at least %d characters", minPasswordLength)
	}
	return nil
}
