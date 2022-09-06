package main

import (
	"log"
	"net/http/fcgi"

	"github.com/piperswe/hellofastcgi/internal/handler"
)

func main() {
	handler.SetupHandler()
	err := fcgi.Serve(nil, nil)
	if err != nil {
		log.Fatalf("FastCGI failed: %v", err)
	}
}
