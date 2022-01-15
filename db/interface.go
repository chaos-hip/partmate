package db

import (
	"fmt"

	"git.chaos-hip.de/RepairCafe/PartMATE/models"
)

var (
	ErrNothingDeleted = fmt.Errorf("no entity deleted")
)

//go:generate go run github.com/maxbrunsfeld/counterfeiter/v6 -generate

//counterfeiter:generate -o mock --fake-name MockDB . DB
type DB interface {
	//-- Parts 🧩 --------------------------------------------

	// GetPartByLink returns the part belonging to the link given
	GetPartByLink(id string) (*models.Part, error)
	// SearchParts searches for the parts matching the given search query and returns a list of them
	// ordered by name
	SearchParts(search models.Search) ([]models.Part, error)

	//-- Storage locations 📦 --------------------------------

	// SearchStorageLocations searches for storage locations matching the provided search term.
	// The result is provided as paginated list
	SearchStorageLocations(search models.Search) ([]models.StorageLocation, error)

	// GetStorageLocationByLink returns the storage location that belongs to the given ID
	GetStorageLocationByLink(id string) (*models.StorageLocation, error)

	//-- Users 👤 --------------------------------------------

	// GetUserByName returns the user with the given username or nothing if the user does not exist
	GetUserByName(name string) (*models.User, error)
	// CreateUser creates a new user in the database
	CreateUser(models.User) error
	// DeleteUser deletes the user with the given name from the database
	DeleteUser(name string) error
	// GetUserList returns a list of all existing user names
	GetUserList() ([]string, error)
	// SetUserPermissions sets the permissions for the selected user based on the given user struct
	SetUserPermissions(models.User) error

	// List all existing login tokens for a given user - optionally returning the expired ones as well
	ListLoginTokensForUser(username string, expired bool) ([]models.LoginToken, error)
	// GetNonExpiredLoginTokenByID returns the given login token model if it exists and is not expired yet
	GetNonExpiredLoginTokenByID(id string) (*models.LoginToken, error)
	// CreateLoginToken creates a new login token for a user
	CreateLoginToken(models.LoginToken) error
	// DeleteLoginToken removes the login token with the given ID
	DeleteLoginToken(id string) error

	//-- Links 🔗 --------------------------------------------

	// DeleteLinkByID will delete the link with the given ID
	DeleteLinkByID(linkID string) error
	// CreateLink creates the link to the given target
	// Passing a link with an empty ID will generate a new ID
	CreateLink(models.Link) (*models.Link, error)
	// GetLinkByID returns the link with the given ID
	// Mainly this is used internally to fetch the DB ID of entities
	GetLinkByID(id string) (*models.Link, error)
	// GetLinksByLinkID returns a list of links that have the same target as the given link, denoting all links a specific
	// item has in the database
	GetLinksByLinkID(id string) ([]*models.Link, error)

	//-- Part Attachments 📎 ---------------------------------

	CreatePartAttachmentEntry(partID, filename, mimeType string) (*models.PartAttachment, error)
	// GetAttachmentsByPartLink returns a list of attachments belonging to the part identified with the given link
	GetAttachmentsByPartLink(partLink string) ([]models.PartAttachment, error)
	GetAttachmentEntry(id string) (*models.PartAttachment, error)

	//-- Stock 📈📉 -------------------------------------------

	// AddPartStock adds one or more instances to the amount of parts present of the selected part type
	AddPartStock(id, price, comment string, amount uint) error
	// RemovePartStock removes one or more parts of the selected part type from the inventory
	RemovePartStock(id, comment string, amount uint) error

	//-- Database 🧨🎢 ----------------------------------------

	// Close closes the database connection
	Close()
}
