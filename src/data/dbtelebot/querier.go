// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.16.0

package dbtelebot

import (
	"context"
)

type Querier interface {
	DeleteAnswersOfClient(ctx context.Context, clientID int32) error
	GetClientByTelegramUserId(ctx context.Context, telegramUserID string) (Client, error)
	GetClientScore(ctx context.Context, clientID int32) (string, error)
	GetOneRandomNotAnsweredQuestion(ctx context.Context, clientID int32) (Question, error)
	GetOptionByQuestionIdAndText(ctx context.Context, arg GetOptionByQuestionIdAndTextParams) (Option, error)
	GetOptionsByQuestionId(ctx context.Context, questionsID int32) ([]Option, error)
	GetQuestionById(ctx context.Context, id int32) (Question, error)
	GetReferencesByQuestionId(ctx context.Context, questionsID int32) ([]Reference, error)
	GetTheLastQuestionAnsweredByClient(ctx context.Context, clientID int32) (ClientHasQuestion, error)
	InsertClient(ctx context.Context, arg InsertClientParams) error
	InsertClientHasQuestions(ctx context.Context, arg InsertClientHasQuestionsParams) error
	SetClientWaitingForAnswer(ctx context.Context, arg SetClientWaitingForAnswerParams) error
	SetClientWaitingForAnswerToFalse(ctx context.Context, id int32) error
	SetClientWaitingForAnswerToTrueAndQuestionId(ctx context.Context, arg SetClientWaitingForAnswerToTrueAndQuestionIdParams) error
}

var _ Querier = (*Queries)(nil)
