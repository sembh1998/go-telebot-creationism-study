package main

import (
	"fmt"
	"log"

	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api/v5"
)

var numericKeyboard = tgbotapi.NewReplyKeyboard(
	tgbotapi.NewKeyboardButtonRow(
		tgbotapi.NewKeyboardButton("1"),
		tgbotapi.NewKeyboardButton("2"),
		tgbotapi.NewKeyboardButton("3"),
	),
	tgbotapi.NewKeyboardButtonRow(
		tgbotapi.NewKeyboardButton("4"),
		tgbotapi.NewKeyboardButton("5"),
		tgbotapi.NewKeyboardButton("6"),
	),
)

func main() {
	fmt.Println("Hello, World!")
	bot, err := tgbotapi.NewBotAPI("YOUR_TOKEN")
	if err != nil {
		log.Panic(err)
	}

	bot.Debug = false

	log.Printf("Authorized on account %s", bot.Self.UserName)
	u := tgbotapi.NewUpdate(0)
	u.Timeout = 60
	updates := bot.GetUpdatesChan(u)
	for update := range updates {
		if update.Message == nil { // ignore any non-Message updates
			continue
		}
		if update.Message != nil { // If we got a message
			log.Printf("[%s] %s", update.Message.From.UserName, update.Message.Text)
			if update.Message.IsCommand() {
				msg := tgbotapi.NewMessage(update.Message.Chat.ID, "")
				switch update.Message.Command() {
				case "help":
					msg.Text = "I understand /sayhi and /status."
				case "sayhi":
					msg.Text = "Hi :)"
				case "status":
					msg.Text = "I'm ok."
				default:
					msg.Text = "I don't know that command"
				}
			} else {
				msg := tgbotapi.NewMessage(update.Message.Chat.ID, "no es un comando")
				msg.ReplyToMessageID = update.Message.MessageID
				msg.ReplyMarkup = numericKeyboard
				bot.Send(msg)
			}
		}
	}

}
