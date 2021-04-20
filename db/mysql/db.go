package mysql

import (
	"database/sql"
	"fmt"

	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/models"
	_ "github.com/go-sql-driver/mysql"
	"github.com/golang-migrate/migrate/v4"
	migratedb "github.com/golang-migrate/migrate/v4/database/mysql"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/jmoiron/sqlx"
)

const (
	migrationTableName = "mate_migrations"
)

type DB struct {
	db *sqlx.DB
}

func (d *DB) GetPartByID(id string) (*models.Part, error) {
	return nil, fmt.Errorf("not implemented \u200d")
}

func (d *DB) SearchParts(search models.Search) ([]models.Part, error) {
	return nil, fmt.Errorf("not implemented \u200d")
}

func (d *DB) GetUserByName(name string) (*models.User, error) {
	return nil, fmt.Errorf("not implemented \u200d")
}

func (d *DB) DeleteLinkByID(id string) error {
	return fmt.Errorf("not implemented \u200d")
}

func (d *DB) CreateLink(id, targetType, target string) (*models.Link, error) {
	return nil, fmt.Errorf("not implemented \u200d")
}

func (d *DB) CreatePartAttachmentEntry(partID, filename, mimeType string) (*models.Attachment, error) {
	return nil, fmt.Errorf("not implemented \u200d")
}

func (d *DB) GetAttachmentEntry(id string) (*models.Attachment, error) {
	return nil, fmt.Errorf("not implemented \u200d")
}

func (d *DB) AddPartStock(id, price, comment string, amount uint) error {
	return fmt.Errorf("not implemented \u200d")
}

func (d *DB) RemovePartStock(id, comment string, amount uint) error {
	return fmt.Errorf("not implemented \u200d")
}

func (d *DB) Close() {
	d.db.Close()
}

func Migrate(db *sql.DB, source string) error {
	drv, err := migratedb.WithInstance(
		db,
		&migratedb.Config{
			MigrationsTable: migrationTableName,
		},
	)
	if err != nil {
		return fmt.Errorf("failed to create migration driver instance: %w", err)
	}
	if source == "" {
		source = "file://dbmigrations"
	}
	migrator, err := migrate.NewWithDatabaseInstance(
		source,
		"mysql", drv,
	)
	if err != nil {
		return fmt.Errorf("failed to create database migrator: %w", err)
	}
	if err := migrator.Up(); err != nil && err != migrate.ErrNoChange {
		return err
	}
	return nil
}

func NewDB(host, port, username, password, dbName, migrationSource string) (db.DB, error) {

	// Create migration connection
	// multiStatements enables batch processing
	sqlDB, err := sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?multiStatements=true", username, password, host, port, dbName))
	if err != nil {
		return nil, fmt.Errorf("failed to connect to database for migration: %w", err)
	}
	defer sqlDB.Close()
	if err := Migrate(sqlDB, migrationSource); err != nil {
		return nil, fmt.Errorf("failed to migrate database: %w", err)
	}

	sqlxDB, err := sqlx.Connect("mysql", fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?multiStatements=true&parseTime=true", username, password, host, port, dbName))
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
