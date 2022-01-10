package mysql

import (
	"database/sql"
	"fmt"
	"strings"

	"git.chaos-hip.de/RepairCafe/PartMATE/models"
)

const (
	userFields    = "name, password_hash, permissions"
	userTableName = "mate_users"
)

// CreateUser creates a new user in the database
func (d *DB) CreateUser(user models.User) error {
	if user.PasswordHash == "" {
		return fmt.Errorf("no password set for new user")
	}
	query := fmt.Sprintf("INSERT INTO %s(%s) VALUES(?, ?, ?)", userTableName, userFields)
	if _, err := d.db.Exec(query, user.Username, user.PasswordHash, user.RawPermissions); err != nil {
		return fmt.Errorf("failed to insert new user: %w", err)
	}
	return nil
}

// GetUserByName returns the user with the given username or nothing if the user does not exist
func (d *DB) GetUserByName(name string) (*models.User, error) {
	u := models.User{}
	// Name is case-insensitive here - so we're normalizing it to lowercase
	name = strings.ToLower(name)
	if err := d.db.Get(&u, fmt.Sprintf("SELECT %s FROM %s WHERE name = ?", userFields, userTableName), name); err != nil {
		if err == sql.ErrNoRows {
			// Nothing found
			return nil, nil
		}
		return nil, fmt.Errorf("failed to fetch user record: %w", err)
	}
	return &u, nil
}

// SetUserPermissions sets the permissions for the selected user based on the given user struct
func (d *DB) SetUserPermissions(u models.User) error {
	if u.RawPermissions == "" {
		return fmt.Errorf("empty permissions data")
	}
	query := fmt.Sprintf("UPDATE %s SET permissions = ? WHERE name = ?", userTableName)
	res, err := d.db.Exec(query, u.RawPermissions, u.Username)
	if err != nil {
		return fmt.Errorf("failed to update user permissions: %w", err)
	}
	num, err := res.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to get affected rows after update: %w", err)
	}
	if num == 0 {
		return fmt.Errorf("user not found")
	}
	return nil
}
