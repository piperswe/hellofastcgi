package handler

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func helloWorldHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Header().Set("content-type", "text/plain")
	world := "world"
	vars := mux.Vars(r)
	newWorld, ok := vars["world"]
	if ok {
		world = newWorld
	}
	fmt.Fprintf(w, "Hello, %s! Request URL is %#v.\n\nHeaders:\n", world, r.URL.String())
	for headerName, headerValue := range r.Header {
		fmt.Fprintf(w, "%#v: %#v\n", headerName, headerValue)
	}
}
