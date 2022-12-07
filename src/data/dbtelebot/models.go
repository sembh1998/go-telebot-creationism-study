// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.16.0

package dbtelebot

import (
	"database/sql"
	"time"
)

type Client struct {
	ID             int32
	Name           string
	ChatID         string
	TelegramUserID string
	// 1: yes;
	// 0: not
	WaitingForAnswer interface{}
	QuestionsID      sql.NullInt32
}

type ClientHasQuestion struct {
	ClientID    int32
	QuestionsID int32
	OptionsID   int32
	Date        time.Time
	// 1: active;
	// 0: deleted
	State interface{}
}

type Option struct {
	ID          int32
	Option      string
	QuestionsID int32
	IsCorrect   interface{}
}

type Question struct {
	ID       int32
	Question string
}

type Reference struct {
	ID          int32
	Name        string
	Text        string
	QuestionsID int32
}
