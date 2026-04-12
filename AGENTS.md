# Workspace

This is a multi-repo workspace. Each registered workspace-relative sub-project is an independent git repository.

- Commit, build, and test each changed git repository from within its own directory
- Do not assume one sub-project's conventions, branches, or tooling apply to another
- Limit changes to the sub-projects required for the task

## Project Structure

<!-- Register each sub-project here using its workspace-relative path. Nested paths are allowed. -->
- `docs/` — knowledge base (notes, decisions, ideas)

## Knowledge Base

`docs/` is the shared knowledge base. Consult it before making architectural changes or answering design questions. Before writing in `docs/`, read `docs/AGENTS.md` and follow its required formats for notes, ideas, and decisions.
