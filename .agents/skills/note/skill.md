---
name: note
description: Capture a new timestamped observation in the knowledge base. Use when the user wants to record an observation, finding, or conclusion as a structured note.
argument-hint: "[observation text]"
allowed-tools: Bash, Read, Write, Glob
---

Capture a new timestamped observation in the knowledge base.

1. Run `date '+%Y-%m-%d %H:%M'` to get the current datetime. Never use placeholders.
2. Derive a short kebab-case slug, three to five words, from the content of `$ARGUMENTS`.
3. Create `notes/YYMMDD-slug.md` where YYMMDD is derived from the current date.
4. Write the file with this structure:

Frontmatter:
```
---
type: note
datetime: YYYY-MM-DD HH:MM
status: current
tags: [tag1, tag2]
---
```

Body:
```
# [Title — sentence case, describes the observation]

YYYY-MM-DD HH:MM<br>
Status: Current

## Claims

- [Atomic, verifiable statements derived from $ARGUMENTS. One per bullet. Distill narrative into discrete claims.]
```

5. Infer one to three relevant tags from the note content and populate the `tags` field.
6. Search existing tags in `notes/`, `ideas/`, and `decisions/` before inventing a new one. Reuse established tags where possible, avoid case variants and near-synonyms, and use `[]` only when no useful tags apply.

If `$ARGUMENTS` is empty, ask the user what they observed or concluded before proceeding.

After writing the file, state the filename and summarize the claims written.
