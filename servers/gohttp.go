package main

import (
    "bytes"
    "fmt"
    "net/http"
    "strconv"
)

var cache map[int][]byte

func handler(w http.ResponseWriter, r *http.Request) {
    size, err := strconv.Atoi(r.URL.Path[1:])
    if err != nil {
        size = 1024
    }

    body, ok := cache[size]
    if ! ok {
        body = bytes.Repeat([]byte{'X'}, size)
        cache[size] = body
    }

    w.Write(body)
}

func main() {
    cache = make(map[int][]byte)
    http.HandleFunc("/", handler)
    fmt.Println("Serving on :25000")
    http.ListenAndServe(":25000", nil)
}
