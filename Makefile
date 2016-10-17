
.PHONY: help

# self-documented makefile
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


build: ## build a docker image named knowledge-base, serving a local version of the knowledge-base on port 4000
	docker build -t knowledge-base .

run: build  ## Run a local version of the knowledge-base and serve it on localhost:4000/kb/
	docker run -ti --rm -p 4000:4000 knowledge-base 
