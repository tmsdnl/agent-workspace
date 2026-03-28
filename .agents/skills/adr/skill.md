---
name: adr
description: Synthesize architectural decision records from notes and ideas. Use when the user wants to capture a decision, promote an idea to a decision, or consolidate notes into a decision document.
argument-hint: "[topic]"
allowed-tools: Read, Edit, Write, Glob, Grep
---

Synthesize decisions from notes and ideas.

Steps:
1. Determine the topic from `$ARGUMENTS`. If not provided, ask.
2. Search for relevant files: `grep -rl "<topic>" notes/ ideas/ 2>/dev/null`. For multiple keywords, use: `grep -rl -E "keyword1|keyword2" notes/ ideas/ 2>/dev/null`.
3. Read only the returned files. Skip any with a `Superseded` blockquote below the title.
4. Read existing decision files that might be affected before deciding to create a new one.
5. For each note or idea, determine:
   - Whether it belongs in decisions at all. Decisions capture protocol-level, architectural, or interface design choices, not runtime or implementation details.
   - Which existing decision file(s) it affects, if any.
   - What specific change is needed: new section, updated section, new citation, or new decision file.
   - Whether the topic fits an existing decision file.
   - Whether an idea's status should change to `accepted` with an outcome link to the decision.
   - Whether forward-looking or deferred content requires no decision update yet.
6. Present a clear summary of proposed changes, file by file and section by section, without making any edits.
7. Wait for explicit approval before making any changes.

When writing or updating decision files, use this structure:

New file:
```
---
type: decision
tags: [tag1, tag2]
---

# [Topic Title]

> [One-sentence summary of what this document covers.]

---
```

Decision section (new or appended):
```
## [Decision Name]

- [Atomic, normative claim about what was decided. One per bullet.]
- [Each bullet should be independently verifiable and precise.]

**Informed by**: [notes/YYMMDD-slug.md](../notes/YYMMDD-slug.md), [ideas/YYMMDD-slug.md](../ideas/YYMMDD-slug.md)

---
```

For a deferred decision, append `*(Deferred)*` to the `##` heading.
Before writing a new decision file, prefer updating an existing topic file when the subject fits.
Reuse established tags where possible. Avoid inventing case variants or near-synonyms.

When a decision is derived from an accepted idea, update the idea's status to `accepted` and add an `## Outcome` section: `Accepted — see [decisions/topic.md § Section](decisions/topic.md)`.

Do not make changes until the user approves.
