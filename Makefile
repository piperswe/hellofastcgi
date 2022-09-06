.PHONY: build
build: bin/hellofastcgi.cgi bin/hellofastcgi.fcgi bin/.htaccess

.PHONY: test
test:
	go test ./...

.PHONY: dev
dev:
	go run -mod=vendor ./cmd/dev

.PHONY: bin
bin:
	mkdir -p bin

GOARCHIVE=go1.19.1.linux-amd64.tar.gz

.PHONY: $(GOARCHIVE)
$(GOARCHIVE):
ifeq ("$(wildcard $(GOARCHIVE))","")
	wget https://go.dev/dl/$(GOARCHIVE)
endif

.PHONY: build-image
build-image: Dockerfile $(GOARCHIVE)
	docker build --platform linux/amd64 -t ghcr.io/piperswe/hellofastcgi/builder -f Dockerfile .

INDOCKER=docker run --rm --platform linux/amd64 --mount type=bind,source="$$(pwd)",target=/app ghcr.io/piperswe/hellofastcgi/builder

.PHONY: bin/hellofastcgi.cgi
bin/hellofastcgi.cgi: bin build-image
	$(INDOCKER) go build -mod=vendor -o bin/hellofastcgi.cgi ./cmd/cgi

.PHONY: bin/hellofastcgi.fcgi
bin/hellofastcgi.fcgi: bin build-image
	$(INDOCKER) go build -mod=vendor -o bin/hellofastcgi.fcgi ./cmd/fastcgi

bin/.htaccess: .htaccess bin
	cp .htaccess bin/

.PHONY: ssh
ssh:
	ssh dh_ptskzf@hellofastcgi.piperswe.me

.PHONY: ssh-copy-id
ssh-copy-id:
	ssh-copy-id dh_ptskzf@hellofastcgi.piperswe.me

.PHONY: deploy
deploy: build test
	rsync -vrP --delete bin/ dh_ptskzf@hellofastcgi.piperswe.me:hellofastcgi.piperswe.me

.PHONY: deploy-debug
deploy-debug: build
	cp .htaccess.debug bin/.htaccess
	rsync -vrP --delete bin/ dh_ptskzf@hellofastcgi.piperswe.me:hellofastcgi.piperswe.me