.SILENT:
.PHONY: build-audiowaveform push-audiowaveform
# Colors
COLOR_RESET   = \033[0m
COLOR_INFO    = \033[32m
COLOR_COMMENT = \033[33m
COLOR_ERROR   = \033[31m

## Help
help:
	printf "$(COLOR_COMMENT)Usage:$(COLOR_RESET)\n"
	printf " make [target]\n\n"
	printf "$(COLOR_COMMENT)Available targets:$(COLOR_RESET)\n"
	awk '/^[a-zA-Z\-\_0-9\.@]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf " ${COLOR_INFO}%-24s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

#################
# Audiowaveform #
#################

AUDIOWAVEFORM_VERSION = 1.4.2

## Build audiowaveform image(s)
build-audiowaveform:
	docker build \
		--tag greedybro/audiowaveform:$(AUDIOWAVEFORM_VERSION) \
		--build-arg AUDIOWAVEFORM_VERSION=$(AUDIOWAVEFORM_VERSION) \
		audiowaveform

## Run temporary audiowaveform container
run-audiowaveform:
	docker run \
		--rm \
		--interactive \
		--tty \
		greedybro/audiowaveform:$(AUDIOWAVEFORM_VERSION) \
		--help

## Sh into temporary audiowaveform container
sh-audiowaveform:
	docker run \
		--rm \
		--interactive \
		--tty \
		--entrypoint /bin/ash \
		greedybro/audiowaveform:$(AUDIOWAVEFORM_VERSION)

## Publish audiowaveform image(s)
push-audiowaveform:
	$(call docker_login)
	docker push \
		greedybro/audiowaveform:$(AUDIOWAVEFORM_VERSION)
