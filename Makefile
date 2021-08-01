# And add help text after each target name starting with '\#\#'
.DEFAULT_GOAL:=help

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

start: ## run application
	docker-compose run --rm --service-ports php /bin/bash

install: ## install depends
	composer install

console: ## install psysh
	composer exec --verbose psysh

lint: ## run linter
	composer exec --verbose phpcs -- --standard=PSR12 src tests
	composer exec --verbose phpstan -- --level=8 analyse src tests

lint-fix: ## run lint-fix
	composer exec --verbose phpcbf -- --standard=PSR12 src tests

test: ## run test
	composer exec --verbose phpunit tests

test-coverage: ## run test coverage
	composer exec --verbose phpunit tests -- --coverage-clover build/logs/clover.xml

.PHONY: test-coverage test lint-fix lint console install start help