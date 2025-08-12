package api

import (
    "encoding/json"
    "net/http"
)

// NewRouter returns a basic HTTP handler with health and version endpoints.
func NewRouter() http.Handler {
    mux := http.NewServeMux()

    mux.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        _ = json.NewEncoder(w).Encode(map[string]string{
            "status": "ok",
        })
    })

    mux.HandleFunc("/version", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        _ = json.NewEncoder(w).Encode(map[string]string{
            "service": "relay-api",
            "version": "0.1.0",
        })
    })

    // TODO: add /devices/register, /oauth/link, /prefs endpoints per Tasks.md

    return mux
}

