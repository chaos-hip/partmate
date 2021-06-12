package db

import "git.chaos-hip.de/RepairCafe/PartMATE/models"

//go:generate go run github.com/maxbrunsfeld/counterfeiter/v6 -generate

//counterfeiter:generate -o mock --fake-name MockDB . DB
type DB interface {
	// Parts 🧩
	GetPartByID(id string) (*models.Part, error)
	SearchParts(search models.Search) ([]models.Part, error)

	// Users 👤
	// GetUserByName returns the user with the given username or nothing if the user does not exist
	GetUserByName(name string) (*models.User, error)
	// CreateUser creates a new user in the database
	CreateUser(models.User) error

	// Links 🔗
	DeleteLinkByID(id string) error
	CreateLink(id, targetType, target string) (*models.Link, error)

	// Attachments 📎
	CreatePartAttachmentEntry(partID, filename, mimeType string) (*models.Attachment, error)
	GetAttachmentEntry(id string) (*models.Attachment, error)

	// Stock 📈📉
	AddPartStock(id, price, comment string, amount uint) error
	RemovePartStock(id, comment string, amount uint) error

	// Database 🧨🎢
	Close()
}
