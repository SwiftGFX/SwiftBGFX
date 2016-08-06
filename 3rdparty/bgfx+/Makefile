#
# Copyright 2011-2016 Branimir Karadzic. All rights reserved.
# License: http://www.opensource.org/licenses/BSD-2-Clause
#

UNAME := $(shell uname)
ifeq ($(UNAME),$(filter $(UNAME),Linux Darwin FreeBSD GNU/kFreeBSD))
ifeq ($(UNAME),$(filter $(UNAME),Darwin))
OS=darwin
else
ifeq ($(UNAME),$(filter $(UNAME),FreeBSD GNU/kFreeBSD))
OS=bsd
else
OS=linux
endif
endif
else
OS=windows

endif

# $(info $(OS))

BX_DIR?=../bx
GENIE?=$(BX_DIR)/tools/bin/$(OS)/genie
PROJECT ?= ninja

.PHONY: help

help:
	@echo Available targets:
	@grep -E "^[a-zA-Z0-9_-]+:.*?## .*$$" $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: ## Clean all intermediate files.
	@echo Cleaning...
	-@rm -rf .build
	@mkdir .build

.build/projects/gmake-android-arm:
	$(GENIE) --gcc=android-arm gmake
android-arm-debug: .build/projects/gmake-android-arm ## Build - Android ARM Debug
	$(MAKE) -R -C .build/projects/gmake-android-arm config=debug
android-arm-release: .build/projects/gmake-android-arm ## Build - Android ARM Release
	$(MAKE) -R -C .build/projects/gmake-android-arm config=release
android-arm: android-arm-debug android-arm-release ## Build - Android ARM Debug and Release

.build/projects/gmake-android-x86:
	$(GENIE) --gcc=android-x86 gmake
android-x86-debug: .build/projects/gmake-android-x86 ## Build - Android x86 Debug and Release
	$(MAKE) -R -C .build/projects/gmake-android-x86 config=debug
android-x86-release: .build/projects/gmake-android-x86 ## Build - Android x86 Debug and Release
	$(MAKE) -R -C .build/projects/gmake-android-x86 config=release
android-x86: android-x86-debug android-x86-release ## Build - Android x86 Debug and Release

.build/projects/gmake-linux:
	$(GENIE) --gcc=linux-gcc gmake
linux-debug32: .build/projects/gmake-linux ## Build - Linux x86 Debug
	$(MAKE) -R -C .build/projects/gmake-linux config=debug32
linux-release32: .build/projects/gmake-linux ## Build - Linux x86 Release
	$(MAKE) -R -C .build/projects/gmake-linux config=release32
linux-debug64: .build/projects/gmake-linux ## Build - Linux x64 Debug
	$(MAKE) -R -C .build/projects/gmake-linux config=debug64
linux-release64: .build/projects/gmake-linux ## Build - Linux x64 Release
	$(MAKE) -R -C .build/projects/gmake-linux config=release64
linux: linux-debug32 linux-release32 linux-debug64 linux-release64 ## Build - Linux x86/x64 Debug and Release

.build/projects/$(PROJECT)-osx:
	$(GENIE) --gcc=osx $(PROJECT)
osx-debug64: .build/projects/$(PROJECT)-osx ## Build - OSX x64 Debug
	$(MAKE) -C .build/projects/$(PROJECT)-osx config=debug64
osx-release64: .build/projects/$(PROJECT)-osx ## Build - OSX x64 Release
	$(MAKE) -C .build/projects/$(PROJECT)-osx config=release64
osx: osx-debug64 osx-release64 ## Build - OSX x64 Debug and Release

.build/projects/gmake-ios-arm:
	$(GENIE) --gcc=ios-arm gmake
ios-arm-debug: .build/projects/gmake-ios-arm ## Build - iOS ARM Debug
	$(MAKE) -R -C .build/projects/gmake-ios-arm config=debug
ios-arm-release: .build/projects/gmake-ios-arm ## Build - iOS ARM Release
	$(MAKE) -R -C .build/projects/gmake-ios-arm config=release
ios-arm: ios-arm-debug ios-arm-release ## Build - iOS ARM Debug and Release

.build/projects/gmake-ios-simulator:
	$(GENIE) --gcc=ios-simulator gmake
ios-simulator-debug: .build/projects/gmake-ios-simulator ## Build - iOS Simulator Debug
	$(MAKE) -R -C .build/projects/gmake-ios-simulator config=debug
ios-simulator-release: .build/projects/gmake-ios-simulator ## Build - iOS Simulator Release
	$(MAKE) -R -C .build/projects/gmake-ios-simulator config=release
ios-simulator: ios-simulator-debug ios-simulator-release ## Build - iOS Simulator Debug and Release

build-darwin: osx

build-linux: linux-debug64 linux-release64

build: build-$(OS)
