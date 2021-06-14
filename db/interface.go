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

	//-- Users 👤 --------------------------------------------

	// GetUserByName returns the user with the given username or nothing if the user does not exist
	GetUserByName(name string) (*models.User, error)
	// CreateUser creates a new user in the database
	CreateUser(models.User) error

	//-- Links 🔗 --------------------------------------------

	// DeleteLinkByID will delete the link with the given ID
	DeleteLinkByID(linkID string) error
	// CreateLink creates the link to the given target
	// Passing a link with an empty ID will generate a new ID
	CreateLink(models.Link) (*models.Link, error)
	// GetLinkByID returns the link with the given ID
	// Mainly this is used internally to fetch the DB ID of entities
	GetLinkByID(id string) (*models.Link, error)

	//-- Attachments 📎 --------------------------------------

	CreatePartAttachmentEntry(partID, filename, mimeType string) (*models.Attachment, error)
	GetAttachmentEntry(id string) (*models.Attachment, error)

	//-- Stock 📈📉 -------------------------------------------

	AddPartStock(id, price, comment string, amount uint) error
	RemovePartStock(id, comment string, amount uint) error

	//-- Database 🧨🎢 ----------------------------------------

	Close()
}
