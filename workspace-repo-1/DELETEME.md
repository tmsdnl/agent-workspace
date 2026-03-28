# Workspace Repo 1

This directory demonstrates how a sub-repo integrates with the workspace via `.agents-md/`.

To replace it with a real sub-repo:

1. Copy `.agents-md/workspace-repo-1.md` → `.agents-md/<name>.md` and fill it in
2. Add `/<name>/` to `.gitignore`
3. Clone: `git clone <url> <name>`
4. Run `make setup` to wire `AGENTS.md` and `CLAUDE.md` symlinks
5. Delete this directory
