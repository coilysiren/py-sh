.DEFAULT_GOAL := help

help: # automatically documents the makefile, by outputing everything behind a ##
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## ⚙️  Build into local environment
	@./scripts/build.sh

test: build ## ✅ Run all checks - tests, linters, etc.
	@./scripts/test.sh
