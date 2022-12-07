-- name: GetClientByTelegramUserId :one
select * from client where telegram_user_id = sqlc.arg(telegram_user_id);

-- name: InsertClient :exec
insert into 
client (name, chat_id, telegram_user_id, waiting_for_answer, questions_id) 
values (sqlc.arg(name), sqlc.arg(chat_id), sqlc.arg(telegram_user_id), sqlc.arg(waiting_for_answer), sqlc.arg(questions_id));

-- name: GetTheLastQuestionAnsweredByClient :one
select * from client_has_questions where client_id = sqlc.arg(client_id) 
and state=1 order by date desc limit 1;

-- name: InsertClientHasQuestions :exec
insert into
client_has_questions (client_id, questions_id, options_id, date, state)
values (sqlc.arg(client_id), sqlc.arg(questions_id), sqlc.arg(options_id), now(), 1);

-- name: GetQuestionById :one
select * from questions where id = sqlc.arg(id);

-- name: GetOptionsByQuestionId :many
select * from options where questions_id = sqlc.arg(questions_id);

-- name: GetReferencesByQuestionId :many
select * from `references` where questions_id = sqlc.arg(questions_id);

-- name: SetClientWaitingForAnswer :exec
update client set waiting_for_answer = sqlc.arg(waiting_for_answer), questions_id=sqlc.arg(question_asked_id) where id = sqlc.arg(id);

-- name: GetOneRandomNotAnsweredQuestion :one
select q.* from questions q 
left join client_has_questions cqa on cqa.questions_id = q.id and cqa.state=1 and cqa.client_id=sqlc.arg(client_id)
where cqa.questions_id is null
order by rand() limit 1;

-- name: GetOptionByQuestionIdAndText :one
select * from options where questions_id = sqlc.arg(questions_id) and `option` = sqlc.arg(text);

-- name: SetClientWaitingForAnswerToFalse :exec
update client set waiting_for_answer = 0 where id = sqlc.arg(id);

-- name: SetClientWaitingForAnswerToTrueAndQuestionId :exec
update client set waiting_for_answer = 1, questions_id = sqlc.arg(questions_id) where id = sqlc.arg(client_id);

-- name: GetClientScore :one
select concat(sum(if(o.is_correct=1,10,0))) puntaje from client_has_questions cqa
left join `options` o on cqa.options_id = o.id
 where state=1 and client_id = sqlc.arg(client_id)
 group by cqa.client_id;

-- name: DeleteAnswersOfClient :exec
update client_has_questions set state=0 where client_id = sqlc.arg(client_id);