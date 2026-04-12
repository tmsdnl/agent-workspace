SHELL := /bin/bash

.DEFAULT_GOAL := help

AGENTS_MD_SRC := $(wildcard .agents-md/*.md)
override REPOSITORIES_FILE := repositories.txt

override REPOSITORIES := $(shell if [ -f "$(REPOSITORIES_FILE)" ]; then awk 'NF && $$1 !~ /^\#/ { print $$1 }' "$(REPOSITORIES_FILE)"; fi)

.PHONY: help setup agents-md clone

help:
	@echo "Usage:"
	@echo "  make setup                         Create workspace agent-instruction symlinks"
	@echo "  make agents-md                     Symlink .agents-md/*.md into each repo"
	@echo "  make clone                         Clone configured repositories into workspace-relative paths"
	@echo ""
	@echo "Repository manifest:"
	@echo "  $(REPOSITORIES_FILE)              One path|url entry per line"
	@echo ""
	@echo "Notes:"
	@echo "  - Repository paths must be workspace-relative"
	@echo "  - Nested paths use / in the repo path and __ in .agents-md filenames"

setup: agents-md
	@[ -e CLAUDE.md ] || ln -sfn AGENTS.md CLAUDE.md

agents-md:
	@symlinked=0; skipped=0; \
	printf "%-45s %s\n" "PATH" "STATUS"; \
	printf "%-45s %s\n" "----" "------"; \
	for f in $(AGENTS_MD_SRC); do \
		name=$${f##*/}; name=$${name%.md}; \
		repo=$${name//__//}; \
		if [ ! -e "$$repo" ]; then \
			printf "%-45s %s\n" "$$repo" "skipped"; \
			skipped=$$((skipped + 1)); \
			continue; \
		fi; \
		if [ ! -d "$$repo" ]; then \
			printf "%-45s %s\n" "$$repo" "skipped"; \
			skipped=$$((skipped + 1)); \
			continue; \
		fi; \
		rel=$$(echo "$$repo" | sed 's|[^/]||g; s|/|../|g')../$$f; \
		rm -f "$$repo/AGENTS.md" "$$repo/CLAUDE.md"; \
		ln -s "$$rel" "$$repo/AGENTS.md"; \
		ln -s "$$rel" "$$repo/CLAUDE.md"; \
		printf "%-45s %s\n" "$$repo" "symlinked"; \
		symlinked=$$((symlinked + 1)); \
	done; \
	printf "\n"; \
	echo "agents-md: symlinked=$$symlinked skipped=$$skipped"

clone:
	@if [ -z "$(strip $(REPOSITORIES))" ]; then \
		echo "No repositories configured. Add entries to $(REPOSITORIES_FILE) and re-run."; \
	else \
		failures=0; \
		for entry in $(foreach entry,$(REPOSITORIES),'$(entry)'); do \
			path=$${entry%%|*}; \
			url=$${entry#*|}; \
			if [ "$$path" = "$$entry" ] || [ -z "$$path" ] || [ -z "$$url" ]; then \
				echo "error: malformed entry '$$entry' (expected path|url)"; \
				failures=$$((failures + 1)); \
				continue; \
			fi; \
			invalid=0; \
			case "$$path" in \
				/*) invalid=1 ;; \
			esac; \
			old_ifs="$$IFS"; IFS='/'; set -- $$path; IFS="$$old_ifs"; \
			for segment in "$$@"; do \
				if [ -z "$$segment" ] || [ "$$segment" = "." ] || [ "$$segment" = ".." ]; then \
					invalid=1; \
					break; \
				fi; \
			done; \
			if [ "$$invalid" -ne 0 ]; then \
				echo "error: invalid workspace-relative path '$$path'"; \
				failures=$$((failures + 1)); \
				continue; \
			fi; \
			dest="$$path"; \
			if [ -e "$$dest/.git" ]; then \
				echo "skip: $$path"; \
				continue; \
			fi; \
			if [ -e "$$dest" ]; then \
				echo "error: destination exists and is not a git repo: $$path"; \
				failures=$$((failures + 1)); \
				continue; \
			fi; \
			mkdir -p "$$(dirname "$$dest")"; \
			echo "clone: $$path"; \
			if ! git clone "$$url" "$$dest"; then \
				echo "error: clone failed: $$path"; \
				failures=$$((failures + 1)); \
			fi; \
		done; \
		[ "$$failures" -eq 0 ]; \
	fi
