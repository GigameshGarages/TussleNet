package main

import (
	"github.com/linkpoolio/bridges"
	"net/http"
	"os"
)

type AlphaVantage struct {}

func (av *AlphaVantage) Run(h *bridges.Helper) (interface{}, error) {
	r := make(map[string]interface{})
	return r, h.HTTPCallWithOpts(
		http.MethodGet,
		"https://www.alphavantage.co/query",
		&r,
		bridges.CallOpts{
			Auth: bridges.NewAuth(bridges.AuthParam, "apikey", os.Getenv("API_KEY")),
			QueryPassthrough: true,
		},
	)
}

func (av *AlphaVantage) Opts() *bridges.Opts {
	return &bridges.Opts{
		Name:   "AlphaVantage",
		Lambda: true,
	}
}

func main() {
	bridges.NewServer(&AlphaVantage{}).Start(8080)
}
