package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func hello(w http.ResponseWriter, r *http.Request) {
	token := r.Header.Get("Authorization")
	body := fmt.Sprintf("Hello World! (Authorization: %s, Time: %s)\n", token, time.Now().Format("2006-01-02 15:04:05 MST"))
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(body))
}

func main() {
	http.HandleFunc("/", hello)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
