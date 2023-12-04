SHELL = /bin/bash

.PHONY: help
help:
	@echo "Commands:"
	@echo "venv            : creates the virtual environment in .venv."
	@echo "install         : install dependencies into virtual environment."
	@echo "compile         : update the environment requirements after changes to dependencies in requirements/*.in files."
	@echo "update          : pip install new requriements into the virtual environment."
	@echo "test            : run pytests."
	@echo "bump-patch      : bump the patch version."
	@echo "bump-minor      : bump the minor version."

# create a virtual environment
.PHONY: venv
venv:
	python3 -m venv .venv
	source .venv/bin/activate && \
	python3 -m pip install pip==23.1.2 setuptools==68.0.0 wheel==0.40.0 && \
	pip install pip-tools==6.14.0

# ==============================================================================
# compile requirements
# ==============================================================================

req-core-in := requirements/core.in   # input file for compilation of core requirements
req-core-out := requirements/core.txt # output file of core requirements compilation
req-dev-in := requirements/dev.in     # input file for compilation of dev requirements
req-dev-out := requirements/dev.txt   # output file of dev requirements compilation

.PHONY: compile
compile: venv
	source .venv/bin/activate && \
	pip-compile $(req-core-in) -o $(req-core-out) --resolver=backtracking && \
	pip-compile $(req-dev-in) -o $(req-dev-out) --resolver=backtracking

.PHONY: compile-dev
compile-dev: venv
	source .venv/bin/activate && \
	pip-compile $(req-dev-in) -o $(req-dev-out) --resolver=backtracking

.PHONY: compile-upgrade
compile-upgrade: venv
	source .venv/bin/activate && \
	pip-compile -U $(req-core-in) -o $(req-core-out) --resolver=backtracking && \
	pip-compile -U $(req-dev-in) -o $(req-dev-out) --resolver=backtracking

# ==============================================================================
# install requirements
# ==============================================================================

# default environment (for local development)
.PHONY: install
install: venv
	source .venv/bin/activate && \
	pip-sync $(req-core-out) $(req-dev-out) && \
	pip install -e . && \
	pre-commit install

# github actions test environment
.PHONY: install-gh-test
install-gh-test:
	pip install -r $(req-core-out) && \
	pip install -e .


# ==============================================================================
# update requirements and virtual env after changes to requirements/*.txt files
# ==============================================================================

.PHONY: update
update:
	source .venv/bin/activate && \
	pip-sync $(req-core-out) $(req-dev-out) && \
	pip install -e .

# ==============================================================================
# run tests
# ==============================================================================

.PHONY: test
test:
	source .venv/bin/activate && \
	pytest -vx .

# ==============================================================================
# bump version
# ==============================================================================

.PHONY: bump-patch
bump-patch:
	source .venv/bin/activate && \
	bumpver update --patch

.PHONY: bump-minor
bump-minor:
	source .venv/bin/activate && \
	bumpver update --minor

# ==============================================================================
# etl
# ==============================================================================

.PHONY: etl
etl:
	source .venv/bin/activate && \
	python src/etl_with_metaflow/flows/etl.py run --source data/
