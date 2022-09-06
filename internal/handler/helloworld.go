package handler

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/piperswe/hellofastcgi/internal/hello"
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
	fmt.Fprintln(w, hello.Hello(world))
	fmt.Fprintf(w, "Request URL is %#v.\n\nHeaders:\n", r.URL.String())
	for headerName, headerValue := range r.Header {
		fmt.Fprintf(w, "%#v: %#v\n", headerName, headerValue)
	}
}
