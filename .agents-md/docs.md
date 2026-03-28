# Knowledge Base

## Layers

- **`notes/`** — Timestamped, atomic observations. Append-only; a note may be deleted only once all its claims are fully captured elsewhere and it no longer serves as a citation target.
- **`decisions/`** — Consolidated records by topic (ADRs). Mutable — sections are added and updated as decisions evolve.
- **`ideas/`** — Forward-looking proposals not yet decided. Lifecycle: `open` → `accepted`, `rejected`, or `superseded`.

## Rules

- **Notes first.** Write the note before recording a decision.
- **Decisions are not history.** They describe what is, not what was. History lives in notes.
- **Ideas are not decisions.** Keep speculative content out of `decisions/` until settled.
- **One concept per section.** Each section covers one decision point.
- **Cite everything.** Every decision section must link to the note(s) and idea(s), if any, that informed it.
- **Supersede explicitly.** When a note is superseded, add `> **Superseded — see [link].**` below its title and set `status: superseded` in frontmatter.
- **Skip superseded.** When scanning `notes/`, skip any file with a `Superseded` blockquote below its title.

## Note Format

`notes/YYMMDD-slug.md` — frontmatter + body.

Frontmatter:
- `type: note`
- `datetime: YYYY-MM-DD HH:MM`
- `status: current` or `superseded`
- `tags: [tag1, tag2]`

Body:
- Required: `# Title`
- Required: `YYYY-MM-DD HH:MM<br>`
- Required: `Status: <Current|Superseded>` — must match frontmatter
- Required: `## Claims` — atomic, verifiable bullets
- Optional: `## Context` — narrative when claims alone are insufficient
- Optional: `## Open Questions`

## Idea Format

`ideas/YYMMDD-slug.md` — frontmatter + body.

Frontmatter:
- `type: idea`
- `datetime: YYYY-MM-DD HH:MM`
- `status: open`, `accepted`, `rejected`, or `superseded`
- `tags: [tag1, tag2]`

Body:
- Required: `# Title`
- Required: `YYYY-MM-DD HH:MM<br>`
- Required: `Status: <Open|Accepted|Rejected|Superseded>` — must match frontmatter
- Required: `## Motivation` — verifiable bullets about what is broken, missing, or improvable
- Required: `## Proposal` — bullets describing what will be true if adopted
- Optional: `## Open Questions`
- Required when resolved: `## Outcome`

`## Outcome` values:
- `Accepted — see [decisions/topic.md § Section](decisions/topic.md)`
- `Rejected: reason`
- `Superseded by [link]`

## Decision Format

`decisions/topic-area.md` — one file per topic, one `##` section per decision point.

Frontmatter:
- `type: decision`
- `tags: [tag1, tag2]`

File header:
- Required: `# Topic Title`
- Required: `> one-sentence summary blockquote`

Decision section:
- Required: `## Decision Name`
- Required: atomic, normative bullets describing what was decided
- Required: `**Informed by**: ...` — links to the notes and ideas that informed the decision
- Required: `---`

Append `*(Deferred)*` to the `##` heading when the decision is planned but not yet implemented.

## Workflow

- Capture new facts and findings as notes first.
- Capture speculative proposals as ideas.
- When notes or ideas resolve into guidance, create or update the relevant decision section and cite sources.
- When an idea is accepted, rejected, or superseded, update its `## Outcome`.

## Skills

- Use the `note` skill to create a new note in `notes/`.
- Use the `idea` skill to create a new proposal in `ideas/`.
- Use the `adr` skill to synthesize or update `decisions/` from notes and ideas.
- The `adr` skill proposes changes first and waits for explicit approval before editing.
- If skills are unavailable, follow the format rules above manually.

## Tags

- Search existing tags before inventing a new one.
- Reuse established tags; avoid case variants and near-synonyms.
- Keep tags short and topic-oriented.
