

.PHONY: docs

docs:
	@echo Making documentation...
	@jazzy \
		--xcodebuild-arguments -scheme,SwiftBGFX \
		-m SwiftBGFX \
		--clean \
		--output docs/output/master
