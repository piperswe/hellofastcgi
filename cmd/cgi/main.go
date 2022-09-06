package main

import (
	"log"
	"net/http/cgi"

	"github.com/piperswe/hellofastcgi/internal/handler"
)

func main() {
	handler.SetupHandler()
	err := cgi.Serve(nil)
	if err != nil {
		log.Fatalf("CGI failed: %v", err)
	}
}
