.PHONY: all lint kubeval test package debug docs docs-serve

all: lint kubeval test package docs

lint:
	helm lint charts/onechart/

kubeval:
	rm -rf manifests && true
	mkdir manifests
	helm template charts/onechart --output-dir manifests
	find manifests/ -name '*.yaml' | xargs kubeval --ignore-missing-schemas -v 1.20.0
	find manifests/ -name '*.yaml' | xargs kubeval --ignore-missing-schemas -v 1.24.0

test:
	helm dependency update charts/onechart
	helm unittest charts/onechart

package:
	helm dependency update charts/onechart
	helm package charts/onechart
	mv onechart*.tgz docs
	# helm repo index docs --url https://chart.onechart.dev

debug:
	helm dependency update charts/onechart
	helm template my-release charts/onechart/ -f values.yaml --debug

docs:
	@echo "Setting up documentation environment..."
	test -d .docs-venv || python3 -m venv .docs-venv
	@echo "Installing dependencies..."
	.docs-venv/bin/pip install -r docs/requirements.txt
	@echo "Building documentation..."
	nix-shell --run "source .docs-venv/bin/activate && cd docs && mkdocs build --clean"
	@echo "Documentation built successfully!"

docs-serve:
	@echo "Setting up documentation environment..."
	test -d .docs-venv || python3 -m venv .docs-venv
	@echo "Installing dependencies..."
	.docs-venv/bin/pip install -r docs/requirements.txt
	@echo "Starting documentation server..."
	nix-shell --run "source .docs-venv/bin/activate && cd docs && mkdocs serve"
