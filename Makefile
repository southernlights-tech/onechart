.PHONY: all lint kubeval test package debug lint-onechart lint-cron-job kubeval-onechart kubeval-cron-job test-onechart test-cron-job package-onechart package-cron-job debug-onechart debug-cron-job

all: lint kubeval test package

lint: lint-onechart lint-cron-job

lint-onechart:
	helm lint charts/onechart/

lint-cron-job:
	helm lint charts/cron-job/

kubeval: kubeval-onechart kubeval-cron-job

kubeval-onechart:
	rm -rf manifests-onechart && true
	mkdir manifests-onechart
	helm template charts/onechart --output-dir manifests-onechart
	find manifests-onechart/ -name '*.yaml' | xargs kubeval --ignore-missing-schemas -v 1.20.0
	find manifests-onechart/ -name '*.yaml' | xargs kubeval --ignore-missing-schemas -v 1.24.0
	rm -rf manifests-onechart

kubeval-cron-job:
	rm -rf manifests-cron-job && true
	mkdir manifests-cron-job
	helm template charts/cron-job --output-dir manifests-cron-job
	find manifests-cron-job/ -name '*.yaml' | xargs kubeval --ignore-missing-schemas -v 1.20.0
	find manifests-cron-job/ -name '*.yaml' | xargs kubeval --ignore-missing-schemas -v 1.24.0
	rm -rf manifests-cron-job

test: test-onechart test-cron-job

test-onechart:
	helm dependency update charts/onechart
	helm unittest charts/onechart

test-cron-job:
	helm dependency update charts/cron-job
	helm unittest charts/cron-job

package: package-onechart package-cron-job

package-onechart:
	helm dependency update charts/onechart
	helm package charts/onechart
	mv onechart*.tgz docs
	helm repo index docs

package-cron-job:
	helm dependency update charts/cron-job
	helm package charts/cron-job
	mv cron-job*.tgz docs
	helm repo index docs

debug: debug-onechart

debug-onechart:
	helm dependency update charts/onechart
	helm template my-release charts/onechart/ -f values.yaml --debug

debug-cron-job:
	helm dependency update charts/cron-job
	helm template my-release charts/cron-job/ -f values-cron-job.yaml --debug
