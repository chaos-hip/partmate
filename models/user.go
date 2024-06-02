package models

import (
	"encoding/json"
	"fmt"
	"strings"

	"github.com/chaos-hip/partmate/auth/hash"
	"github.com/chaos-hip/partmate/models/permission"
	"github.com/golang-jwt/jwt/v4"
	"github.com/sirupsen/logrus"
)

const (
	minPasswordLength = 8
)

// User is the Struct to identify the User (Table: mate_users)
type User struct {
	Username       string          `db:"name"`
	PasswordHash   string          `db:"password_hash"` // Swordfish
	RawPermissions string          `db:"permissions"`
	permissions    map[string]bool `db:"-"` // Decoded permissions - only set the first time they are used
}

// CheckPassword takes a given password and checks if the password has matches that input
func (u *User) CheckPassword(input string) bool {
	hashData, err := hash.FromString(u.PasswordHash)
	if err != nil {
		logrus.WithError(err).Errorf("Failed to decode password hash for user %#v: %s", u.Username, err.Error())
	}
	return hashData.Matches(input)
}

// ToDTO converts the user DB model to its DTO representation
func (u *User) ToDTO() UserDTO {
	return UserDTO{
		Username:    u.Username,
		Permissions: u.Permissions(),
	}
}

// Permissions returns the decoded permission slice
func (u *User) Permissions() []string {
	perms := []string{}
	if err := json.Unmarshal([]byte(u.RawPermissions), &perms); err != nil {
		logrus.WithError(err).Errorf("Failed to decode permissions for user %#v", u.Username)
		return nil
	}
	return perms
}

// Can checks if the user can execute an operation requiring all of the given permissions
func (u *User) Can(perms ...string) bool {
	if u.permissions == nil {
		// Load the permissions into the map
		u.permissions = make(map[string]bool)
		tmpPerm := u.Permissions()
		for _, perm := range tmpPerm {
			u.permissions[perm] = true
		}
	}
	for _, checkedPerm := range perms {
		if _, ok := u.permissions[checkedPerm]; !ok {
			return false
		}
	}
	return true
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
		hashData, err := hash.NewArgon(u.Password)
		if err != nil {
			return nil, fmt.Errorf("failed to create password hash for user: %w", err)
		}
		out.PasswordHash = hashData.String()
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
	if err := u.ValidatePermissions(); err != nil {
		return err
	}
	return nil
}

// ValidatePermissions checks if the provided user DTO's permissions are valid for storing permissions
func (u *UserDTO) ValidatePermissions() error {
	invalidPermissions := []string{}
	for _, perm := range u.Permissions {
		if !permission.Exists(perm) {
			invalidPermissions = append(invalidPermissions, perm)
		}
	}
	if len(invalidPermissions) > 0 {
		return fmt.Errorf("invalid permissions: %+v", invalidPermissions)
	}
	return nil
}

// PermissionClaims is a JWT claim struct that has an added permissions array
type PermissionClaims struct {
	jwt.RegisteredClaims
	Permissions []string `json:"perm,omitempty"`
}
