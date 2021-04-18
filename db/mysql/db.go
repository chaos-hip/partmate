package mysql

import (
	"fmt"

	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/models"
	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
)

type DB struct {
	db *sqlx.DB
}

func (d *DB) GetPartByID(id string) (*models.Part, error) {
	return nil, fmt.Errorf("nich implementiert \u200d")
}

func (d *DB) SearchParts(search models.Search) ([]models.Part, error) {
	return nil, fmt.Errorf("nich implementiert \u200d")
}

func (d *DB) GetUserByName(name string) (*models.User, error) {
	return nil, fmt.Errorf("nich implementiert \u200d")
}

func (d *DB) DeleteLinkByID(id string) error {
	return fmt.Errorf("nich implementiert \u200d")
}

func (d *DB) CreateLink(id, targetType, target string) (*models.Link, error) {
	return nil, fmt.Errorf("nich implementiert \u200d")
}

func (d *DB) CreatePartAttachmentEntry(partID, filename, mimeType string) (*models.Attachment, error) {
	return nil, fmt.Errorf("nich implementiert \u200d")
}

func (d *DB) GetAttachmentEntry(id string) (*models.Attachment, error) {
	return nil, fmt.Errorf("nich implementiert \u200d")
}

func (d *DB) AddPartStock(id, price, comment string, amount uint) error {
	return fmt.Errorf("nich implementiert \u200d")
}

func (d *DB) RemovePartStock(id, comment string, amount uint) error {
	return fmt.Errorf("nich implementiert \u200d")
}

func (d *DB) Close() {
	d.db.Close()
}

func NewDB(host, port, username, password, dbName string) (db.DB, error) {
	sqlxDB, err := sqlx.Connect("mysql", fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true", username, password, host, port, dbName))

	if err != nil {
		return nil, fmt.Errorf("failed to connect to database: %w", err)
	}

	return NewDBWithConnection(sqlxDB), nil
}

func NewDBWithConnection(conn *sqlx.DB) db.DB {
	return &DB{
		db: conn,
	}
}
