.PHONY: build
build: bin/hellofastcgi.cgi bin/hellofastcgi.fcgi bin/.htaccess

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
build-image: Dockerfile.builder $(GOARCHIVE)
	docker build -t hellofastcgi-builder -f Dockerfile.builder .

INDOCKER=docker run --rm --mount type=bind,source="$$(pwd)",target=/app hellofastcgi-builder

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

.PHONY: deploy
deploy: build
	rsync -vrP --delete bin/ dh_ptskzf@hellofastcgi.piperswe.me:hellofastcgi.piperswe.me

.PHONY: deploy-debug
deploy-debug: build
	cp .htaccess.debug bin/.htaccess
	rsync -vrP --delete bin/ dh_ptskzf@hellofastcgi.piperswe.me:hellofastcgi.piperswe.me