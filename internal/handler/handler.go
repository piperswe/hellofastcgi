package handler

import (
	"net/http"

	"github.com/gorilla/mux"
)

func SetupHandler() {
	r := mux.NewRouter()
	r.HandleFunc("/", helloWorldHandler)
	r.HandleFunc("/hello/{world}", helloWorldHandler)
	http.Handle("/", r)
}
