.DEFAULT_GOAL := help

# grab the repo name from the git origin
name := `yq r repo.yml name`

help: # automatically documents the makefile, by outputing everything behind a ##
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Prereqs:
# 	- homebrew => https://brew.sh/
# 	- docker => `brew cask install docker`
# 	- yq => `brew install yq`

clean: ## 🗑️  Clear local files and assets
	@./src/clean.sh $(name)

build: ## ⚙️  Build into local environment - for osx
	@./src/prebuild-run-osx.sh $(name)
	docker exec $(name) src/build.sh

test: build ## ✅ Run all checks - tests, linters, etc.
	docker exec $(name) src/test.sh
