package bootstrap

//load envs
import (
	"log"

	"github.com/joho/godotenv"
)

type Bootstrap struct {
}

func (b Bootstrap) Init() {
	log.Println("Loading envs")
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
}
