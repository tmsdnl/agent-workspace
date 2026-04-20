# Workspace

This is a multi-repo workspace. Each registered workspace-relative sub-project is an independent git repository.

Read this file first to understand how the workspace is organized. Then use the repo-local `AGENTS.md` in the sub-project you are changing for repo-specific guidance.

- Commit, build, and test each changed git repository from within its own directory
- Do not assume one sub-project's conventions, branches, or tooling apply to another
- Limit changes to the sub-projects required for the task

When creating or updating `.agents-md/<repo>.md`, optimize for agents already working inside that repository:

- Start with a short root-first pointer so agents understand the workspace before the local details
- Focus on repo-local conventions, boundaries, commands, and verification
- Keep workspace history or cross-repo explanation brief unless it changes how work should be done in that repo
- Use the root `AGENTS.md` for shared workspace guidance instead of repeating it in every repo file

## Project Structure

<!-- Register each sub-project here using its workspace-relative path. Nested paths are allowed. -->
- `docs/` — knowledge base (notes, decisions, ideas)

## Knowledge Base

`docs/` is the shared knowledge base. Consult it before making architectural changes or answering design questions. Before writing in `docs/`, read `docs/AGENTS.md` and follow its required formats for notes, ideas, and decisions.
