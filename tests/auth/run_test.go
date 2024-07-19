package auth

import (
	"net/http"
	"sync"
	"testing"
)

var wg sync.WaitGroup

func Test_todoRequest(t *testing.T) {
	r := NewRequest()
	r.Method = http.MethodPost
	for range 500 {
		wg.Add(1)
		go func() {
			r.request(
				todoEndpoint,
				map[string]any{
					"title":     randomRunes(),
					"completed": true,
				},
			)
		}()
	}
	wg.Wait()
}

func Test_cepRequest(t *testing.T) {
	r := NewRequest()
	for range 100 {
		wg.Add(1)
		go func() {
			defer wg.Done()
			r.request(
				cepEndpoint,
				nil,
			)
		}()
	}
	wg.Wait()
}
