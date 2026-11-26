GOVULNCHECK_VER := v1.10.0
VERSION ?= 0.0.0
APP := dist/MyWhoosh2Garmin.app

.PHONY: check tidy vet test vuln app

check: tidy vet test vuln

tidy:
	go mod tidy -diff

vet:
	go vet ./...

test:
	go test ./...

vuln:
	go run golang.org/x/vuln/cmd/govulncheck@$(GOVULNCHECK_VER) ./...

app:
	rm -rf $(APP) dist/mywhoosh2garmin-macos.zip
	mkdir -p $(APP)/Contents/MacOS
	GOARCH=arm64 CGO_ENABLED=1 go build -ldflags "-s -w" -o dist/mw-arm64 .
	GOARCH=amd64 CGO_ENABLED=1 go build -ldflags "-s -w" -o dist/mw-amd64 .
	lipo -create -output $(APP)/Contents/MacOS/mywhoosh2garmin dist/mw-arm64 dist/mw-amd64
	rm dist/mw-arm64 dist/mw-amd64
	sed 's/@VERSION@/$(VERSION)/g' packaging/Info.plist > $(APP)/Contents/Info.plist
	codesign --force --sign - $(APP)
	ditto -c -k --keepParent $(APP) dist/mywhoosh2garmin-macos.zip
