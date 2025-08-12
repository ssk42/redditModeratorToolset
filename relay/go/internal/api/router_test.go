package api

import (
    "encoding/json"
    "net/http"
    "net/http/httptest"
    "testing"
)

func TestHealthz(t *testing.T) {
    router := NewRouter()
    req := httptest.NewRequest(http.MethodGet, "/healthz", nil)
    w := httptest.NewRecorder()
    router.ServeHTTP(w, req)

    if w.Code != http.StatusOK {
        t.Fatalf("expected 200, got %d", w.Code)
    }

    var body map[string]string
    if err := json.Unmarshal(w.Body.Bytes(), &body); err != nil {
        t.Fatalf("failed to parse body: %v", err)
    }
    if body["status"] != "ok" {
        t.Fatalf("unexpected body: %v", body)
    }
}

