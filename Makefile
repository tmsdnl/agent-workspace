SHELL := /bin/zsh

.DEFAULT_GOAL := help

CLAUDE_SKILLS_DST := $(HOME)/.claude/skills
AGENTS_SKILLS_DST := $(HOME)/.agents/skills
SKILLS_SRC        := $(CURDIR)/.agents/skills

VALID_AGENTS  := claude codex all
ALL_SKILLS    := $(sort $(filter-out .gitkeep,$(notdir $(wildcard $(SKILLS_SRC)/*))))

SKILL_COMMANDS    := install update list status prune uninstall
SKILLS_CMD        := $(word 2,$(MAKECMDGOALS))
SKILLS_SKILL_ARGS := $(wordlist 3,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

AGENT ?= all
RESOLVED_AGENTS  := $(if $(filter all,$(AGENT)),codex claude,$(AGENT))

# REQUESTED_SKILLS may be passed as an override from the skills dispatcher
REQUESTED_SKILLS ?=
TARGET_SKILLS     = $(if $(REQUESTED_SKILLS),$(REQUESTED_SKILLS),$(ALL_SKILLS))
UNKNOWN_SKILLS    = $(filter-out $(ALL_SKILLS),$(REQUESTED_SKILLS))

ifeq ($(FORCE),1)
RSYNC_FLAGS := -av --delete
else
RSYNC_FLAGS := -av --update
endif

.PHONY: help setup agents-md \
        skills $(SKILL_COMMANDS) \
        skills-install skills-update skills-list skills-status skills-prune skills-uninstall

define assert_valid_skill_selection
	@if [[ ! " $(VALID_AGENTS) " == *" $(AGENT) "* ]]; then \
		echo "Unknown AGENT: $(AGENT). Valid values: $(VALID_AGENTS)"; exit 1; fi
	@if [ -n "$(UNKNOWN_SKILLS)" ]; then \
		echo "Unknown skill(s): $(UNKNOWN_SKILLS). Available: $(ALL_SKILLS)"; exit 1; fi
	@if [ -z "$(ALL_SKILLS)" ]; then \
		echo "No skills found under $(SKILLS_SRC)"; exit 1; fi
endef

# ── Help ──────────────────────────────────────────────────────────────────────

help:
	@echo "Usage:"
	@echo "  make setup                         Create all workspace symlinks"
	@echo "  make agents-md                     Symlink .agents-md/*.md into each repo"
	@echo "  make skills <command> [skill ...]  Manage skills (see below)"
	@echo ""
	@echo "Skills commands:"
	@echo "  make skills install   [skill]      Install skills globally"
	@echo "  make skills update    [skill]      Alias of install"
	@echo "  make skills list      [skill]      Show local and installed skills"
	@echo "  make skills status    [skill]      Show drift between local and installed"
	@echo "  make skills prune                  Remove globally installed skills not present locally"
	@echo "  make skills uninstall [skill]      Remove globally installed skills"
	@echo ""
	@echo "  AGENT=codex|claude|all (default: all)   FORCE=1 to overwrite newer files"
	@echo ""
	@echo "  Source:  $(SKILLS_SRC)"
	@echo "  Agents:  $(AGENTS_SKILLS_DST)"
	@echo "  Claude:  $(CLAUDE_SKILLS_DST)"
	@if [ -n "$(ALL_SKILLS)" ]; then printf "  Skills:  %s\n" "$(ALL_SKILLS)"; \
	else echo "  Skills:  (none)"; fi

# ── Workspace ─────────────────────────────────────────────────────────────────

setup: agents-md
	@mkdir -p .claude
	@ln -sfn ../.agents/skills .claude/skills

agents-md:
	@for f in .agents-md/*.md; do \
		repo=$${f##*/}; repo=$${repo%.md}; \
		if [ -d "$$repo" ]; then \
			ln -sfn ../$$f $$repo/AGENTS.md; \
			ln -sfn ../$$f $$repo/CLAUDE.md; \
		else \
			echo "skipping $$f: repo '$$repo' not found"; \
		fi; \
	done

# ── Skills dispatcher ─────────────────────────────────────────────────────────

skills:
	@if [ -z "$(SKILLS_CMD)" ] || [[ ! " $(SKILL_COMMANDS) " == *" $(SKILLS_CMD) "* ]]; then \
		echo "Usage: make skills <command> [skill ...] [AGENT=codex|claude|all] [FORCE=1]"; \
		echo "Commands: $(SKILL_COMMANDS)"; \
		exit $$([ -z "$(SKILLS_CMD)" ] && echo 0 || echo 1); \
	else \
		$(MAKE) --no-print-directory skills-$(SKILLS_CMD) REQUESTED_SKILLS="$(SKILLS_SKILL_ARGS)"; \
	fi

# Absorb subcommand words so Make doesn't treat them as build targets
$(SKILL_COMMANDS):
	@:

# ── Skills targets ────────────────────────────────────────────────────────────

skills-install skills-update:
	$(assert_valid_skill_selection)
	@skills=($(TARGET_SKILLS)); \
	mkdir -p "$(AGENTS_SKILLS_DST)"; \
	for skill in $$skills; do \
		rsync $(RSYNC_FLAGS) "$(SKILLS_SRC)/$$skill/" "$(AGENTS_SKILLS_DST)/$$skill/"; \
	done; \
	echo "installed: $(AGENTS_SKILLS_DST) ($${skills[*]})"; \
	if [ -d "$(CLAUDE_SKILLS_DST)" ] && [ ! -L "$(CLAUDE_SKILLS_DST)" ]; then \
		for skill in $$skills; do \
			rsync $(RSYNC_FLAGS) --exclude 'codex/' --exclude 'codex/**' \
				"$(SKILLS_SRC)/$$skill/" "$(CLAUDE_SKILLS_DST)/$$skill/"; \
		done; \
		echo "installed: $(CLAUDE_SKILLS_DST) ($${skills[*]})"; \
	elif [ ! -e "$(CLAUDE_SKILLS_DST)" ]; then \
		ln -sfn "$(AGENTS_SKILLS_DST)" "$(CLAUDE_SKILLS_DST)"; \
		echo "linked: $(CLAUDE_SKILLS_DST) -> $(AGENTS_SKILLS_DST)"; \
	fi

skills-list:
	$(assert_valid_skill_selection)
	@codex=($(RESOLVED_AGENTS)); skills=($(TARGET_SKILLS)); \
	printf "%-8s %-12s %-7s %-10s %s\n" "AGENT" "SKILL" "LOCAL" "INSTALLED" "DESCRIPTION"; \
	printf "%-8s %-12s %-7s %-10s %s\n" "-----" "-----" "-----" "---------" "-----------"; \
	for agent in $$codex; do \
		case "$$agent" in \
			codex) dst="$(AGENTS_SKILLS_DST)" ;; \
			claude) dst="$(CLAUDE_SKILLS_DST)"  ;; \
		esac; \
		for skill in $$skills; do \
			desc=$$(sed -n "s/^description: *['\"]\\{0,1\\}\\(.*\\)['\"]\\{0,1\\}$$/\\1/p" \
				"$(SKILLS_SRC)/$$skill/skill.md" 2>/dev/null | head -1); \
			installed="✗"; [ -d "$$dst/$$skill" ] && installed="✓"; \
			printf "%-8s %-12s %-7s %-10s %s\n" "$$agent" "$$skill" "✓" "$$installed" "$$desc"; \
		done; \
	done

skills-status:
	$(assert_valid_skill_selection)
	@codex=($(RESOLVED_AGENTS)); skills=($(TARGET_SKILLS)); any=0; \
	printf "%-8s %-40s %s\n" "AGENT" "FILE" "STATUS"; \
	printf "%-8s %-40s %s\n" "-----" "----" "------"; \
	for agent in $$codex; do \
		case "$$agent" in \
			codex) dst_root="$(AGENTS_SKILLS_DST)"; rsync_extra=() ;; \
			claude) dst_root="$(CLAUDE_SKILLS_DST)";  rsync_extra=(--exclude 'codex/' --exclude 'codex/**') ;; \
		esac; \
		for skill in $$skills; do \
			src="$(SKILLS_SRC)/$$skill/"; dst="$$dst_root/$$skill/"; \
			all=$$(rsync -rn "$${rsync_extra[@]}" --out-format='%n' "$$src" "$$dst" 2>/dev/null \
				| sed '/^$$/d; /^\.$$/d; /^\.\/$$/d' | LC_ALL=C sort); \
			[ -z "$$all" ] && continue; \
			any=1; \
			updatable=$$(rsync -run "$${rsync_extra[@]}" --out-format='%n' "$$src" "$$dst" 2>/dev/null \
				| sed '/^$$/d; /^\.$$/d; /^\.\/$$/d' | LC_ALL=C sort); \
			source_newer=$$(comm -12 <(printf '%s\n' "$$all") <(printf '%s\n' "$$updatable")); \
			while IFS= read -r file; do \
				[ -z "$$file" ] && continue; \
				if [ ! -e "$$dst/$$file" ]; then state="new"; \
				elif printf '%s\n' "$$source_newer" | grep -qx "$$file"; then state="← local is newer"; \
				else state="→ installed is newer (skipped)"; fi; \
				printf "%-8s %-40s %s\n" "$$agent" "$$skill/$$file" "$$state"; \
			done <<< "$$all"; \
		done; \
	done; \
	[ "$$any" -eq 0 ] && echo "All files are in sync."

skills-prune:
	$(assert_valid_skill_selection)
	@codex=($(RESOLVED_AGENTS)); \
	for agent in $$codex; do \
		case "$$agent" in \
			codex) dst_root="$(AGENTS_SKILLS_DST)" ;; \
			claude) dst_root="$(CLAUDE_SKILLS_DST)"  ;; \
		esac; \
		[ -d "$$dst_root" ] || continue; pruned=0; \
		for dir in "$$dst_root"/*; do \
			[ -d "$$dir" ] || continue; name=$${dir:t}; \
			if [[ ! " $(ALL_SKILLS) " == *" $$name "* ]]; then \
				rm -rf "$$dir"; echo "pruned $$agent: $$name"; pruned=1; \
			fi; \
		done; \
		[ "$$pruned" -eq 1 ] || echo "nothing to prune for $$agent"; \
	done

skills-uninstall:
	$(assert_valid_skill_selection)
	@codex=($(RESOLVED_AGENTS)); skills=($(TARGET_SKILLS)); \
	for agent in $$codex; do \
		case "$$agent" in \
			codex) dst_root="$(AGENTS_SKILLS_DST)" ;; \
			claude) dst_root="$(CLAUDE_SKILLS_DST)"  ;; \
		esac; \
		removed=0; \
		for skill in $$skills; do \
			if [ -d "$$dst_root/$$skill" ]; then \
				rm -rf "$$dst_root/$$skill"; echo "removed $$agent: $$skill"; removed=1; \
			fi; \
		done; \
		[ "$$removed" -eq 1 ] || echo "no skills removed for $$agent"; \
	done
