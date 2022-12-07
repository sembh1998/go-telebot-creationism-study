package data

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/go-sql-driver/mysql"
)

type MysqlConnection struct {
	Conn *sql.DB
}

var singleton *MysqlConnection

func GetMySQLStringConnection() string {
	dataBase := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		os.Getenv("MYSQL_USER"),
		os.Getenv("MYSQL_PASS"),
		os.Getenv("MYSQL_HOST"),
		os.Getenv("MYSQL_PORT"),
		os.Getenv("MYSQL_DB"))

	return dataBase
}

func GetMysqlConnection() *MysqlConnection {
	if singleton == nil {
		conn, err := sql.Open("mysql", GetMySQLStringConnection())
		if err != nil {
			panic(err)
		}
		singleton = &MysqlConnection{Conn: conn}
		log.Println("Mysql connection created")
	}
	return singleton
}
