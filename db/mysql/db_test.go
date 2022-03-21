package mysql_test

import (
	"fmt"
	"os"
	"path/filepath"
	"testing"

	"github.com/chaos-hip/partmate/db"
	"github.com/chaos-hip/partmate/db/mysql"
	"github.com/jmoiron/sqlx"
	"github.com/lithammer/shortuuid/v3"
	. "github.com/smartystreets/goconvey/convey"
)

const (
	migrationSource = "file://../../dbmigrations"
)

func TestDBConnect(t *testing.T) {
	Convey("connecting to a database", t, func() {
		db, err := mysql.NewDB("127.0.0.1", "3306", "partmate", "partmate", "partmate", migrationSource, "./")
		So(err, ShouldBeNil)
		So(db, ShouldNotBeNil)

		Convey("connecting with wrong credentials should fail", func() {
			db, err := mysql.NewDB("127.0.0.1", "3306", "partfiend", "partmate", "partmate", migrationSource, "./")
			So(err, ShouldNotBeNil)
			So(db, ShouldBeNil)
		})

		Reset(func() {
			db.Close()
		})
	})

}

func TestMigrate(t *testing.T) {
	Convey("Having a database connection", t, func() {
		db, sqlxDB, err := connectToDb()
		So(err, ShouldBeNil)
		So(db, ShouldNotBeNil)
		So(sqlxDB, ShouldNotBeNil)

		Convey("Migrating up to the current version should work flawlessly", func() {
			err := mysql.Migrate(sqlxDB.DB, migrationSource)
			So(err, ShouldBeNil)
		})

		Reset(func() {
			destroyDB(sqlxDB)
		})

	})
}

func connectToDb() (db.DB, *sqlx.DB, error) {
	// enable multiStatements to support multiple queries in one Exec()
	sqlxDB, err := sqlx.Connect("mysql", "partmate:partmate@tcp(localhost:3306)/?parseTime=true&multiStatements=true")
	if err != nil {
		return nil, nil, err
	}

	if _, err := sqlxDB.Exec(fmt.Sprintf("CREATE DATABASE IF NOT EXISTS %s;", dbName)); err != nil {
		return nil, nil, err
	}

	if _, err := sqlxDB.Exec(fmt.Sprintf("USE `%s`;", dbName)); err != nil {
		return nil, nil, err
	}

	data, err := os.ReadFile(filepath.Join(".", "testdata", "test.sql"))
	if err != nil {
		return nil, nil, err
	}

	if _, err := sqlxDB.DB.Exec(string(data)); err != nil {
		return nil, nil, err
	}

	foo := mysql.NewDBWithConnection(sqlxDB, "./")
	return foo, sqlxDB, nil
}

var dbName = fmt.Sprintf("partmate_%s", shortuuid.New())

func destroyDB(sqlxDB *sqlx.DB) error {
	if _, err := sqlxDB.Exec(fmt.Sprintf("DROP DATABASE IF EXISTS %s;", dbName)); err != nil {
		return err
	}

	sqlxDB.Close()
	return nil
}
