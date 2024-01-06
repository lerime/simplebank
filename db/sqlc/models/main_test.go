package db

import (
	"database/sql"
	_ "github.com/lib/pq"
	"os"
	"testing"
)

const (
	dbDriver = "postgres"
	dbSource = "postgresql://postgres:123456@localhost:6432/simple_bank?sslmode=disable"
)

var testQueries *Queries
var testDB *sql.DB

func TestMain(m *testing.M) {
	var err error

	testDB, err = sql.Open(dbDriver, dbSource)
	if err != nil {
		panic("cannot connect to db: " + err.Error())
	}
	testQueries = New(testDB)
	os.Exit(m.Run())
}
