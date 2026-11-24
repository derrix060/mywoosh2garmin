GOVULNCHECK_VER := v1.10.0

.PHONY: check tidy vet test vuln

check: tidy vet test vuln

tidy:
	go mod tidy -diff

vet:
	go vet ./...

test:
	go test ./...

vuln:
	go run golang.org/x/vuln/cmd/govulncheck@$(GOVULNCHECK_VER) ./...
