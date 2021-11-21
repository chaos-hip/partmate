package mysql

import (
	"database/sql"
	"fmt"

	"github.com/golang-migrate/migrate/v4"
	migratedb "github.com/golang-migrate/migrate/v4/database/mysql"
	"github.com/sirupsen/logrus"
)

const (
	migrationTableName = "mate_migrations"
)

// Migrate is a helper function to migrate the database up to its most recent version
func Migrate(db *sql.DB, source string) error {
	logrus.Info("Running database migrations...")
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
	logrus.Info("Migrations done")
	return nil
}
