package main

import (
	"log"
	"net/http"

	"github.com/piperswe/hellofastcgi/internal/handler"
)

func main() {
	handler.SetupHandler()
	log.Println("Listening on http://localhost:3000")
	err := http.ListenAndServe(":3000", nil)
	if err != nil {
		log.Fatalf("ListenAndServe failed: %v", err)
	}
}
