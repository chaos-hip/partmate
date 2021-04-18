package mysql_test

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/db/mysql"
	"github.com/jmoiron/sqlx"
	"github.com/lithammer/shortuuid/v3"
	. "github.com/smartystreets/goconvey/convey"
)

func TestDBConnect(t *testing.T) {
	Convey("connecting to a database", t, func() {
		db, err := mysql.NewDB("127.0.0.1", "3306", "partmate", "partmate", "partmate")
		So(err, ShouldBeNil)
		So(db, ShouldNotBeNil)

		Convey("connecting with wrong credentials should fail", func() {
			db, err := mysql.NewDB("127.0.0.1", "3306", "partfiend", "partmate", "partmate")
			So(err, ShouldNotBeNil)
			So(db, ShouldBeNil)
		})

		Reset(func() {
			db.Close()
		})
	})

}

func TestFoo(t *testing.T) {
	Convey("doing things", t, func() {
		dings, bums, err := connectToDb()
		So(err, ShouldBeNil)
		So(dings, ShouldNotBeNil)
		So(bums, ShouldNotBeNil)

	})
}

func connectToDb() (db.DB, *sqlx.DB, error) {
	sqlxDB, err := sqlx.Connect("mysql", "partmate:partmate@tcp(localhost:3306)/?parseTime=true")
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

	parts := strings.Split(string(data), ";")

	for _, qry := range parts {

		if strings.TrimSpace(qry) != "" {
			if _, err := sqlxDB.DB.Exec(qry + ";"); err != nil {
				return nil, nil, err
			}
		}

	}

	foo := mysql.NewDBWithConnection(sqlxDB)
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
