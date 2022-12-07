package usecases

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"go-telebot-creationism-study/src/data"
	"go-telebot-creationism-study/src/data/dbtelebot"

	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api/v5"
)

func SimpleResponse(update tgbotapi.Update, bot *tgbotapi.BotAPI) error {
	if update.Message.Chat.ID < 0 {
		msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Hola "+update.Message.From.FirstName+"!, no puedo responder a grupos, solo a usuarios individuales")
		bot.Send(msg)
		return nil
	}
	mysqlconn := data.GetMysqlConnection()
	db := dbtelebot.New(mysqlconn.Conn)

	user, err := db.GetClientByTelegramUserId(context.Background(), fmt.Sprint(update.Message.From.ID))
	if err != nil && err != sql.ErrNoRows {
		msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Error al obtener el usuario")
		bot.Send(msg)
		fmt.Println("error al obtener el usuario: ", err)
		return err
	}
	if err == sql.ErrNoRows {
		err = db.InsertClient(context.Background(), dbtelebot.InsertClientParams{
			Name:           update.Message.From.FirstName + " " + update.Message.From.LastName,
			ChatID:         fmt.Sprint(update.Message.From.ID),
			TelegramUserID: fmt.Sprint(update.Message.From.ID),
			WaitingForAnswer: sql.NullInt64{
				Int64: 0,
				Valid: true,
			},
			QuestionsID: sql.NullInt32{
				Int32: 0,
				Valid: false,
			},
		})
		if err != nil {
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Error al insertar el usuario")
			bot.Send(msg)
			fmt.Println("error al insertar el usuario: ", err)
			return err
		}
		user, err = db.GetClientByTelegramUserId(context.Background(), fmt.Sprint(update.Message.From.ID))
		if err != nil && err != sql.ErrNoRows {
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Error al obtener el usuario despues de insertarlo")
			bot.Send(msg)
			fmt.Println("error al obtener el usuario: ", err)
			return err
		}
	}
	if update.Message.Text == "/restart" {
		err = db.DeleteAnswersOfClient(context.Background(), user.ID)
		if err != nil {
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Error al reiniciar el estudio")
			bot.Send(msg)
			fmt.Println("error al reiniciar el estudio: ", err)
			return err
		}
		err = db.SetClientWaitingForAnswerToFalse(context.Background(), user.ID)
		if err != nil {
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Error al reiniciar el estudio")
			bot.Send(msg)
			fmt.Println("error al reiniciar el estudio: ", err)
			return err
		}
		msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Estudio reiniciado!")
		bot.Send(msg)
		SendANewQuestion(update, bot, user)
		return nil
	}
	if user.WaitingForAnswer.([]uint8)[0] == 1 {
		option_selected, err := db.GetOptionByQuestionIdAndText(context.Background(), dbtelebot.GetOptionByQuestionIdAndTextParams{
			QuestionsID: user.QuestionsID.Int32,
			Text:        update.Message.Text,
		})
		if err != nil && err != sql.ErrNoRows {
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Error al obtener la opcion seleccionada")
			bot.Send(msg)
			fmt.Println("error al obtener la opcion seleccionada: ", err)
			return err
		}
		if err == sql.ErrNoRows {
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Opcion no valida, por favor selecciona una de las opciones disponibles")
			bot.Send(msg)
			return nil
		}
		err = db.InsertClientHasQuestions(context.Background(), dbtelebot.InsertClientHasQuestionsParams{
			ClientID:    user.ID,
			OptionsID:   option_selected.ID,
			QuestionsID: user.QuestionsID.Int32,
		})
		if err != nil {
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Error al registrar su respuesta")
			bot.Send(msg)
			fmt.Println("error al insertar la respuesta: ", err)
			return err
		}
		db.SetClientWaitingForAnswerToFalse(context.Background(), user.ID)
		if option_selected.IsCorrect.([]uint8)[0] == 1 {
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Respuesta correcta!")
			bot.Send(msg)
		} else {
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Respuesta incorrecta!")
			bot.Send(msg)
		}
		SendANewQuestion(update, bot, user)
	} else {
		SendANewQuestion(update, bot, user)
	}

	return nil
}

func SendANewQuestion(update tgbotapi.Update, bot *tgbotapi.BotAPI, user dbtelebot.Client) error {
	mysqlconn := data.GetMysqlConnection()
	db := dbtelebot.New(mysqlconn.Conn)
	for i := 0; i < 4; i++ {
		msg := tgbotapi.NewMessage(update.Message.Chat.ID, ".")
		bot.Send(msg)
	}
	new_question, err := db.GetOneRandomNotAnsweredQuestion(context.Background(), user.ID)
	if err != nil && err != sql.ErrNoRows {
		msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Error al obtener la siguiente pregunta")
		bot.Send(msg)
		fmt.Println("error al obtener la siguiente pregunta: ", err)
		return err
	}
	if err == sql.ErrNoRows {
		if user.WaitingForAnswer.([]uint8)[0] == 1 {
			go db.SetClientWaitingForAnswerToFalse(context.Background(), user.ID)
		}
		msg := tgbotapi.NewMessage(update.Message.Chat.ID, "No hay mas preguntas, gracias por responder!")
		bot.Send(msg)
		puntaje, err := db.GetClientScore(context.Background(), user.ID)
		if err != nil {
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Error al obtener el puntaje")
			bot.Send(msg)
			fmt.Println("error al obtener el puntaje: ", err)
			return err
		}
		msg = tgbotapi.NewMessage(update.Message.Chat.ID, "Tu puntaje es: "+fmt.Sprint(puntaje)+"/100 puntos")
		bot.Send(msg)
		msg = tgbotapi.NewMessage(update.Message.Chat.ID, "Si deseas volver a responder la encuesta, escribe /restart")
		msg.ReplyMarkup = tgbotapi.NewRemoveKeyboard(true)
		bot.Send(msg)
		return nil
	}
	go db.SetClientWaitingForAnswerToTrueAndQuestionId(context.Background(), dbtelebot.SetClientWaitingForAnswerToTrueAndQuestionIdParams{
		QuestionsID: sql.NullInt32{
			Int32: new_question.ID,
			Valid: true,
		},
		ClientID: user.ID,
	})
	msg := tgbotapi.NewMessage(update.Message.Chat.ID, "")
	references, err := GetQuestionReferences(new_question.ID)
	ref := "Para la pregunta #" + fmt.Sprint(new_question.ID) + " consultar las siguientes referencias:\n"
	if err != nil {
		fmt.Println("error al obtener las referencias: ", err)
		msg.Text = "Error al obtener las referencias"
		bot.Send(msg)
		return err
	}
	msg.ParseMode = "Markdown"
	for _, reference := range references {

		ref += fmt.Sprintf("[%s](%s)  ", reference.Name, reference.Url)

	}
	msg.Text = ref
	bot.Send(msg)
	options_keyboard, err := GetOptionsKeyboard(new_question.ID)
	if err != nil {
		fmt.Println("error al obtener las opciones: ", err)
		msg.Text = "Error al obtener las opciones"
		bot.Send(msg)
		return err
	}
	msg = tgbotapi.NewMessage(update.Message.Chat.ID, new_question.Question)
	msg.ReplyMarkup = options_keyboard
	bot.Send(msg)
	return nil

}

type Reference struct {
	Name string
	Url  string
}

func GetQuestionReferences(question_id int32) ([]Reference, error) {
	mysqlconn := data.GetMysqlConnection()
	db := dbtelebot.New(mysqlconn.Conn)

	references, err := db.GetReferencesByQuestionId(context.Background(), question_id)
	if err != nil {
		fmt.Println("error al obtener las referencias de la pregunta: ", err)
		return nil, errors.New("error al obtener las referencias de la pregunta")
	}
	var references_text []Reference
	for _, reference := range references {
		references_text = append(references_text, Reference{
			Name: reference.Name,
			Url:  reference.Text,
		})
	}

	return references_text, nil
}

func GetQuestion(question_id int32) (string, error) {
	mysqlconn := data.GetMysqlConnection()
	db := dbtelebot.New(mysqlconn.Conn)

	question, err := db.GetQuestionById(context.Background(), question_id)
	if err != nil {
		fmt.Println("error al obtener la pregunta: ", err)
		return "", errors.New("error al obtener la pregunta")
	}

	return question.Question, nil
}

func GetOptionsKeyboard(question_id int32) (tgbotapi.ReplyKeyboardMarkup, error) {
	mysqlconn := data.GetMysqlConnection()
	db := dbtelebot.New(mysqlconn.Conn)

	options, err := db.GetOptionsByQuestionId(context.Background(), question_id)
	if err != nil {
		fmt.Println("error al obtener las opciones de la pregunta: ", err)
		return tgbotapi.NewReplyKeyboard(), errors.New("error al obtener las opciones de la pregunta")
	}
	var keyboard [][]tgbotapi.KeyboardButton
	for _, option := range options {
		keyboard = append(keyboard, tgbotapi.NewKeyboardButtonRow(tgbotapi.NewKeyboardButton(option.Option)))
	}

	return tgbotapi.NewReplyKeyboard(keyboard...), nil
}
