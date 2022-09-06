package handler

import (
	"net/http"

	"github.com/gorilla/mux"
)

func CreateHandler() http.Handler {
	r := mux.NewRouter()
	r.HandleFunc("/", helloWorldHandler)
	r.HandleFunc("/hello/{world}", helloWorldHandler)
	return r
}

func SetupHandler() {
	http.Handle("/", CreateHandler())
}
