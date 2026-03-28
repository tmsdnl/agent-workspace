# Agent Workspace

A template for organising related git repositories under a shared root, with a shared knowledge base, parallel multi-agent support, and skills.

## Setup

### Prerequisites: Codex

If you are using Codex, add the following to `~/.codex/config.toml` so Codex treats `.root` as the workspace root across all sub-projects:

```toml
project_root_markers = [".root", ".git"]
```

### Installation

```
git clone <this-template> my-workspace
cd my-workspace
make setup
```

`make setup` creates `AGENTS.md` and `CLAUDE.md` symlinks in each sub-project — referred to throughout as **agent instructions**. These allow coding agents to locate the workspace root and access the shared knowledge base.

## Motivation

The primary goal is a **shared knowledge base** across related project repositories — for gathering context, analysing codebases, making decisions, driving architecture, and coordinating work without scattering that knowledge across individual project histories or outside the project entirely.

A secondary benefit is running multiple agents in parallel on different tasks. Agent instructions give Claude Code, Codex, and others shared access to the same instructions and knowledge base — so each agent stays in context regardless of which task or repo it is working in.

The workspace should be a private git repository. Each subdirectory is an independent git repository, so their histories stay independent. Sub-projects can be public while the workspace stays private.

```
workspace/
  .root                     ← marks the workspace root (used by Codex)
  .agents-md/               ← agent instructions, one file per git repository
  .agents/skills/           ← agent skills source
  .gitignore
  AGENTS.md
  Makefile
  docs/                     ← knowledge base
  workspace-repo-1/         ← example sub-projects
  workspace-repo-2/
  ...
```

### Typical Workflows

**Day-to-day development:**
1. Record ideas and notes using skills
2. Feed into context or planning mode
3. Execute; capture findings as notes
4. Repeat

**Analysing a large or complex codebase:**
1. Prompt agents to analyse architecture, design, and wiring
2. Capture findings as notes
3. Feed into context or planning mode
4. Execute, repeat

The knowledge base evolves as the project grows. Older documents can be compacted, archived, or deleted as they become irrelevant.

## Knowledge Base

`docs/` is the workspace knowledge base. Its authoring conventions are defined in `.agents-md/docs.md` and exposed via agent instructions after `make setup`.

By default the knowledge base is committed as part of this workspace repo. It can also be maintained as an independent git repository — see `docs/DELETEME.md`.

## Skills

Skills in `.agents/skills/` are available to Codex (via `.agents/skills/` discovery) and to Claude Code via a local `.claude/skills` symlink created by `make setup`. To install them globally:

```
make skills install
```

See `make help` for the full skills lifecycle (`list`, `status`, `prune`, `uninstall`).

> **Note:** `make skills install` creates `~/.claude/skills` as a symlink to `~/.agents/skills` if it does not exist. If `~/.claude/skills` is already a directory, skills are copied into it without overwriting newer files.

## Adding a Sub-Project

Each sub-project is a related, independent git repository inside the workspace directory.

1. Clone or initialise the sub-project:
   ```
   git clone <url> <name>
   # or
   git init <name>
   ```
2. Add `/<name>/` to `.gitignore`
3. Copy `.agents-md/template.md` → `.agents-md/<name>.md` and fill it in
4. Register the sub-project in the root `AGENTS.md` under **Sub-Projects**
5. Run `make agents-md` to generate agent instructions for the sub-project

Agent instructions direct coding agents to the workspace root, where the root `AGENTS.md` maps the full project structure — listing all sub-projects and pointing agents to sibling instructions and the knowledge base. They can also carry project-specific instructions.

