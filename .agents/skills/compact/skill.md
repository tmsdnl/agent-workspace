---
name: compact
description: Compact notes and ideas — merge related files, deduplicate claims, and archive superseded content. Use when the knowledge base has accumulated redundant, thin, or superseded files that should be consolidated.
argument-hint: "[topic | notes | ideas | all]"
allowed-tools: Bash, Read, Edit, Write, Glob, Grep, mcp__datetime__get_current_datetime
---

Compact notes and ideas in the knowledge base by merging related files, deduplicating claims, and archiving superseded content.

1. Determine scope from `$ARGUMENTS`:
   - A topic keyword: search that topic across `notes/` and `ideas/`, whichever exist.
   - A directory name (`notes`, `ideas`, `all`): operate on that directory or all that exist.
   - Empty: ask the user which directory or topic to compact.

2. Discover candidate files:
   - For a topic: `grep -rl -i "<topic>" notes/ ideas/ 2>/dev/null` and omit directories that do not exist.
   - For a directory: glob all `*.md` files in it.

3. Read all candidate files. Detect format from the presence of `---` frontmatter. Analyze as a set:
   - **ARCHIVE**: the file's status is already Superseded, or all its claims are wholly covered by a newer file or decision with no information loss.
   - **MERGE A + B [+ …] → new-slug**: two or more files share the same topic and have redundant or complementary claims that should be collapsed into one denser file.
   - **ABSORB thin → target**: the file has two or fewer unique claims and fits cleanly inside a larger related file.
   - **PRUNE file [claim list]**: specific claims within a file are stale, covered by a decision, or contradicted by a later note.
   - **KEEP**: no action warranted.

4. Present a compact plan, one line per file, with the proposed action and a one-sentence rationale. Do not make any edits yet.

5. Wait for explicit approval. The user may approve the full plan, modify individual actions, or cancel.

6. Execute approved actions:

   **MERGE**: Write the merged file. Use the most recent datetime among sources. Take the union of tags. Include only unique, non-redundant claims, deduplicating near-verbatim statements and keeping the more precise version. Then archive each source file: set `status: archived` in frontmatter, if present, and add a blockquote `> Merged into [new-file.md](new-file.md).` immediately below the title.

   **ARCHIVE**: Set `status: superseded` in frontmatter, if present, and in the Status line in the body. Add a blockquote `> Superseded by [file.md](file.md).` immediately below the title.

   **ABSORB**: Append the source file's unique claims to the target file's relevant section. Then archive the source using the same format as ARCHIVE, replacing "Superseded by" with "Absorbed into".

   **PRUNE**: Remove only the listed claims from the file. Leave all other content intact.

7. Summarize the result: files merged, archived, pruned, and the net reduction in file count.

Format for archived or superseded files with frontmatter:
```
---
type: note
datetime: ...
status: archived
tags: [...]
---

# [Original Title]

> Merged into [new-slug.md](new-slug.md).

[original body, untouched]
```

Format for files without frontmatter:
```
# [Original Title]

> Superseded by [file.md](file.md).

[original body, untouched]
```

Do not make any changes until the user explicitly approves the plan.
