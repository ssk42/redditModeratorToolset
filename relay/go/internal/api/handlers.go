package api

import (
	"encoding/json"
	"net/http"
)

type apiError struct {
	Error string `json:"error"`
}

func writeJSON(w http.ResponseWriter, status int, payload any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(payload)
}

// DeviceRegisterHandler handles /devices/register
func DeviceRegisterHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		writeJSON(w, http.StatusMethodNotAllowed, apiError{Error: "method not allowed"})
		return
	}
	// TODO: parse body { platform, pushToken, prefs?, appVersion? }
	writeJSON(w, http.StatusOK, map[string]string{"status": "accepted"})
}

// OAuthLinkHandler handles /oauth/link
func OAuthLinkHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		writeJSON(w, http.StatusMethodNotAllowed, apiError{Error: "method not allowed"})
		return
	}
	// TODO: accept PKCE exchange payload or refresh token envelope
	writeJSON(w, http.StatusOK, map[string]string{"status": "linked"})
}

// PrefsHandler handles GET/PUT /prefs
func PrefsHandler(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodGet:
		// TODO: load prefs for user
		writeJSON(w, http.StatusOK, map[string]any{"prefs": map[string]any{}})
	case http.MethodPut:
		// TODO: validate and save prefs
		writeJSON(w, http.StatusOK, map[string]string{"status": "updated"})
	default:
		writeJSON(w, http.StatusMethodNotAllowed, apiError{Error: "method not allowed"})
	}
}

// DebugTestPushHandler handles /debug/test-push
func DebugTestPushHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		writeJSON(w, http.StatusMethodNotAllowed, apiError{Error: "method not allowed"})
		return
	}
	// TODO: invoke push provider with a mock payload
	writeJSON(w, http.StatusOK, map[string]string{"status": "sent"})
}
