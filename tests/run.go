package tests

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"math/rand"
	"net/http"
	"os"
	"time"

	"github.com/joho/godotenv"
)

func init() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
}

func randomRunes() string {
	letterRunes := []rune("abcdefghijklmnopqrstuvwxyz")
	rand.NewSource(time.Now().UnixNano())
	b := make([]rune, 8)
	for i := range b {
		b[i] = letterRunes[rand.Intn(len(letterRunes))]
	}

	randomWord := string(b)
	return randomWord
}

var (
	todoEndpoint = fmt.Sprintf("http://%s/td/todos", os.Getenv("EXTERNAL_IP"))
	cepEndpoint  = fmt.Sprintf("http://%s/cep/01023-001", os.Getenv("EXTERNAL_IP"))
	ipEndpoint   = fmt.Sprintf("http://%s/ip", os.Getenv("EXTERNAL_IP"))
)

type Request struct {
	client *http.Client
	Method string
}

func NewRequest() *Request {
	return &Request{
		client: &http.Client{
			Timeout: 10 * time.Second,
			Transport: &http.Transport{
				TLSClientConfig: &tls.Config{
					InsecureSkipVerify: true,
				},
			},
		},
		Method: http.MethodGet,
	}
}

func (r *Request) request(endpoint string, data map[string]any) {
	jsonData, err := json.Marshal(data)
	if err != nil {
		log.Println("Error marshaling data:", err)
		return
	}

	req, err := http.NewRequest(r.Method, endpoint, bytes.NewBuffer(jsonData))
	if err != nil {
		log.Println("Error creating request:", err)
		return
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("apikey", os.Getenv("API_KEY"))
	resp, err := r.client.Do(req)
	if err != nil {
		log.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}

	log.Println("Response status:", resp.Status)
	log.Printf("Body: %s", body)
}
