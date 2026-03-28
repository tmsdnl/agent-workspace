---
name: idea
description: Capture a new idea or proposal in the knowledge base. Use when the user wants to record a design proposal, feature idea, or improvement suggestion.
argument-hint: "[idea description]"
allowed-tools: Bash, Read, Write, Glob
---

Capture a new idea or proposal in the knowledge base.

1. Run `date '+%Y-%m-%d %H:%M'` to get the current datetime. Never use placeholders.
2. Derive a short kebab-case slug, three to five words, from `$ARGUMENTS`.
3. Create `ideas/YYMMDD-slug.md`.
4. Write the file with this structure:

Frontmatter:
```
---
type: idea
datetime: YYYY-MM-DD HH:MM
status: open
tags: [tag1, tag2]
---
```

Body:
```
# [Title]

YYYY-MM-DD HH:MM<br>
Status: Open

## Motivation

- [Verifiable facts about what is broken, missing, or improvable. One per bullet.]

## Proposal

- [Design assertions about what will be true. One per bullet.]

## Open Questions *(optional)*

- [Unresolved issues that shape or block the proposal]
```

5. Infer one to three relevant tags from the idea content and populate the `tags` field.
6. Search existing tags in `notes/`, `ideas/`, and `decisions/` before inventing a new one. Reuse established tags where possible, avoid case variants and near-synonyms, and use `[]` only when no useful tags apply.

If `$ARGUMENTS` is empty, ask the user to describe the idea, what problem it solves and what they propose, before proceeding.

After writing, state the filename.
