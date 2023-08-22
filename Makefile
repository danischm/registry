.PHONY: clean
clean:
	./scripts/clean.sh

.PHONY: ensure
ensure:
	./scripts/ensure.sh

.PHONY: lint
lint:
	./scripts/lint.sh

.PHONY: lint-fix
lint-fix:
	./scripts/lint.sh --fix

.PHONY: test
test:
	./scripts/test.sh

.PHONY: build
build:
	./scripts/build.sh preview

.PHONY: serve
serve:
	./scripts/serve.sh

.PHONY: ci-pull-request
ci-pull-request: ensure
	./scripts/ci/pull-request.sh

.PHONY: ci-pull-request-closed
ci-pull-request-closed:
	./scripts/ci/pull-request-closed.sh

.PHONY: ci-scheduled
ci-scheduled:
	./scripts/ci/scheduled.sh

.PHONY: ci_push
ci_push::
	$(MAKE) ensure
	./scripts/ci/push.sh
