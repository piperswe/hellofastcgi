.PHONY: build
build:
	nix build

.PHONY: deploy
deploy:
	nix run '.#deploy'

.PHONY: deploy-debug
deploy-debug:
	nix run '.#deploy-debug'

.PHONY: ssh
ssh:
	nix run '.#ssh'

.PHONY: dev
dev:
	nix run '.#dev'

.PHONY: test
test:
	nix run '.#go' -- test -race ./...