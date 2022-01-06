package mysql

import (
	"database/sql"
	"fmt"
	"text/template"

	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	_ "github.com/go-sql-driver/mysql"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/jmoiron/sqlx"
)

const (
	defaultPageSize = 10
	maximumPageSize = 100
)

type DB struct {
	db      *sqlx.DB
	dataDir string
}

// NewDB creates a new DB instance by using the given connection parameters
// It will also migrate the database to the most recent version
func NewDB(host, port, username, password, dbName, migrationSource, dataDir string) (db.DB, error) {

	host = template.URLQueryEscaper(host)
	port = template.URLQueryEscaper(port)
	username = template.URLQueryEscaper(username)
	password = template.URLQueryEscaper(password)
	dbName = template.URLQueryEscaper(dbName)

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

	sqlxDB, err := sqlx.Connect("mysql", fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true", username, password, host, port, dbName))
	if err != nil {
		return nil, fmt.Errorf("failed to connect to database: %w", err)
	}

	return NewDBWithConnection(sqlxDB, dataDir), nil
}

// NewDBWithConnection creates a new DB instance using an existing SQLX DB connection
//
// The data dir parameter is used to get the files corresponding to attachments from the file system
//
// ATTENTION: This func will NOT perform a database migration!
func NewDBWithConnection(conn *sqlx.DB, dataDir string) db.DB {
	return &DB{
		db:      conn,
		dataDir: dataDir,
	}
}

// Close closes the database connection
func (d *DB) Close() {
	d.db.Close()
}
