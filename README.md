# Agent Workspace

A workspace template that groups related git repos under a shared knowledge base and shared AI agent instructions.

- Knowledge (notes, decisions, architecture) lives in one place (`docs/`) instead of scattered across repos or lost outside the project
- AI coding agents (Claude Code, Codex, etc.) get the same context regardless of which repo they're working in

```
workspace/
  AGENTS.md              ← shared agent instructions
  docs/                  ← knowledge base (notes, decisions, ideas)
  Makefile               ← setup and repo cloning
  repositories.txt       ← clone manifest
  service-a/             ← independent git repo
  platform/api/          ← nested independent git repo
```

Each sub-project is an independent git repository with its own history. The workspace itself should be a private repository — sub-projects inside it can be public.

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
```

If you want the workspace to clone repositories for you, add `path|url` entries to `repositories.txt` and run:

```
make clone
```

Then create agent instructions:

```
make setup
```

`make setup` creates a root `CLAUDE.md` shim to `AGENTS.md` and symlinks `AGENTS.md` and `CLAUDE.md` into each registered sub-project. Those symlinks point agents to the workspace root instructions and the shared knowledge base. Re-run `make agents-md` after adding or cloning sub-projects.

## Knowledge Base

`docs/` is the workspace knowledge base. Its authoring conventions are defined in `.agents-md/docs.md` and exposed via agent instructions after `make setup`.

By default the knowledge base is committed as part of this workspace repo. It can also be maintained as an independent git repository at `docs/`; if you split it out, add `/docs/` to the workspace `.gitignore` and keep `.agents-md/docs.md` as the instruction source used to generate `docs/AGENTS.md`.

## Adding a Sub-Project

1. Add a `path|url` entry to `repositories.txt` and run `make clone`
2. Add `/<path>/` to `.gitignore`
3. Copy `.agents-md/template.md` to `.agents-md/<path-with-/-replaced-by-__>.md` and fill it in
4. Register the sub-project in the root `AGENTS.md` under **Project Structure**
5. Run `make agents-md` to generate agent instructions for the sub-project

`repositories.txt` format:

```
path/to/repository|https://git.example.com/org/repository.git
```

- Paths must be workspace-relative; nested paths are allowed
- Blank lines and `#` comments are ignored
- Existing cloned repositories are skipped automatically
- `.agents-md` filenames encode `/` as `__`

## Workflows

**Day-to-day development:**
1. Record ideas and notes in `docs/` (manually or with tools that follow the same format)
2. Feed into context or planning mode
3. Execute; capture findings as notes
4. Repeat

**Analysing a codebase:**
1. Prompt agents to analyse architecture, design, and wiring
2. Capture findings as notes
3. Feed into context or planning mode
4. Execute, repeat

The knowledge base evolves as the project grows. Older documents can be compacted, archived, or deleted as they become irrelevant.

This template ships no bundled skills. If you use external or globally installed tools, they should produce notes, ideas, and decisions that follow the formats in `.agents-md/docs.md`.
