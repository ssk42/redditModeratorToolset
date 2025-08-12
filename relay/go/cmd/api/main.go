package main

import (
    "log"
    "net/http"
    "os"
    "time"

    api "github.com/stephenreitz/redditModeratorToolset/relay/go/internal/api"
)

func main() {
    router := api.NewRouter()

    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    server := &http.Server{
        Addr:              ":" + port,
        Handler:           router,
        ReadTimeout:       10 * time.Second,
        ReadHeaderTimeout: 10 * time.Second,
        WriteTimeout:      10 * time.Second,
        IdleTimeout:       60 * time.Second,
    }

    log.Printf("relay api listening on :%s", port)
    if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
        log.Fatalf("server error: %v", err)
    }
}

