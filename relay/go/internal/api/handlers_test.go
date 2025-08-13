package api

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestDeviceRegisterHandler_AllowsPostOnly(t *testing.T) {
	// Method not allowed
	req := httptest.NewRequest(http.MethodGet, "/devices/register", nil)
	w := httptest.NewRecorder()
	DeviceRegisterHandler(w, req)
	if w.Code != http.StatusMethodNotAllowed {
		t.Fatalf("expected 405, got %d", w.Code)
	}

	// Success path
	req = httptest.NewRequest(http.MethodPost, "/devices/register", strings.NewReader(`{"platform":"ios"}`))
	w = httptest.NewRecorder()
	DeviceRegisterHandler(w, req)
	if w.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", w.Code)
	}
	var body map[string]string
	_ = json.Unmarshal(w.Body.Bytes(), &body)
	if body["status"] != "accepted" {
		t.Fatalf("unexpected body: %v", body)
	}
}

func TestOAuthLinkHandler_AllowsPostOnly(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/oauth/link", nil)
	w := httptest.NewRecorder()
	OAuthLinkHandler(w, req)
	if w.Code != http.StatusMethodNotAllowed {
		t.Fatalf("expected 405, got %d", w.Code)
	}

	req = httptest.NewRequest(http.MethodPost, "/oauth/link", strings.NewReader(`{}`))
	w = httptest.NewRecorder()
	OAuthLinkHandler(w, req)
	if w.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", w.Code)
	}
}

func TestPrefsHandler_GetAndPut(t *testing.T) {
	// GET
	req := httptest.NewRequest(http.MethodGet, "/prefs", nil)
	w := httptest.NewRecorder()
	PrefsHandler(w, req)
	if w.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", w.Code)
	}

	// PUT
	req = httptest.NewRequest(http.MethodPut, "/prefs", strings.NewReader(`{"prefs":{}}`))
	w = httptest.NewRecorder()
	PrefsHandler(w, req)
	if w.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", w.Code)
	}

	// Method not allowed
	req = httptest.NewRequest(http.MethodPost, "/prefs", strings.NewReader(`{}`))
	w = httptest.NewRecorder()
	PrefsHandler(w, req)
	if w.Code != http.StatusMethodNotAllowed {
		t.Fatalf("expected 405, got %d", w.Code)
	}
}

func TestDebugTestPushHandler_AllowsPostOnly(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/debug/test-push", nil)
	w := httptest.NewRecorder()
	DebugTestPushHandler(w, req)
	if w.Code != http.StatusMethodNotAllowed {
		t.Fatalf("expected 405, got %d", w.Code)
	}

	req = httptest.NewRequest(http.MethodPost, "/debug/test-push", strings.NewReader(`{}`))
	w = httptest.NewRecorder()
	DebugTestPushHandler(w, req)
	if w.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", w.Code)
	}
}
