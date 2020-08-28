package testapi

import (
	"encoding/json"
	"net/http"
)

func ReadyGet(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)

	b, _ := json.Marshal(ReadyResponse{
		Service: "test",
		Status:  "ok",
	})
	_, _ = w.Write(b)
}
