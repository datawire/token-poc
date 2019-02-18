package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

func getDuration(name string, defval time.Duration) time.Duration {
	val := os.Getenv(name)
	if val != "" {
		result, err := time.ParseDuration(val)
		if err != nil {
			panic(err)
		} else {
			return result
		}
	}
	return defval
}

var (
	TIMEOUT  time.Duration
	OVERHEAD time.Duration
)

func init() {
	TIMEOUT = getDuration("TIMEOUT", 30*time.Second)
	OVERHEAD = getDuration("OVERHEAD", 250*time.Millisecond)
}

func authenticate(w http.ResponseWriter, r *http.Request) {
	time.Sleep(OVERHEAD)
	w.WriteHeader(http.StatusOK)

	var body = make(map[string]interface{})
	body["Token"] = "Yay!"
	body["Timeout"] = TIMEOUT.Seconds()

	b, err := json.MarshalIndent(body, "", "  ")
	if err != nil {
		b = []byte(fmt.Sprintf("Error: %v", err))
	}

	w.Write(b)
}

func main() {
	http.HandleFunc("/authenticate", authenticate)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
