.PHONY: all lint kubeval test package debug

all: lint kubeval test package

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
