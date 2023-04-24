package main

import (
	log "github.com/sirupsen/logrus"
	"html/template"
	"net/http"
	"os"
)

func home(w http.ResponseWriter, r *http.Request) {
	log.Info("endpoint hit: home")

	t, err := template.ParseFiles("/app/main.html")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	acceptableStyles := map[string]bool{
		"table-active":    true,
		"table-primary":   true,
		"table-secondary": true,
		"table-success":   true,
		"table-danger":    true,
		"table-warning":   true,
		"table-info":      true,
		"table-light":     true,
		"table-dark":      true,
	}

	tableStyle, set := os.LookupEnv("TABLE_STYLE")
	if !set || !acceptableStyles[tableStyle] {
		tableStyle = ""
	}

	data_struct := struct {
		NodeName     string
		PodName      string
		PodNamespace string
		PodIP        string
		PodSa        string
		LimitCPU     string
		LimitMem     string
		RequestCPU   string
		RequestMem   string
		TableStyle   string
	}{
		NodeName:     os.Getenv("NODE_NAME"),
		PodName:      os.Getenv("POD_NAME"),
		PodNamespace: os.Getenv("POD_NAMESPACE"),
		PodIP:        os.Getenv("POD_IP"),
		PodSa:        os.Getenv("POD_SA"),
		LimitCPU:     os.Getenv("LIMIT_CPU"),
		LimitMem:     os.Getenv("LIMIT_MEM"),
		RequestCPU:   os.Getenv("REQUEST_CPU"),
		RequestMem:   os.Getenv("REQUEST_MEM"),
		TableStyle:   tableStyle,
	}

	w.WriteHeader(http.StatusOK)
	t.Execute(w, data_struct)
}

func main() {
	http.HandleFunc("/", home)
	log.Info("server started on port 8080")
	http.ListenAndServe(":8080", nil)
}
