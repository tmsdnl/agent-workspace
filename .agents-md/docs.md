# Knowledge Base

Read workspace root `AGENTS.md` first: `../AGENTS.md`.

## Where To Look

- Search `decisions/` first for current, consolidated guidance on a topic.
- Search `notes/` next for atomic findings, evidence, and implementation details. Skip notes marked superseded.
- Search `ideas/` for proposals that are still open or were later accepted, rejected, or superseded.

## Rules

- **Notes first.** Write the note before recording a decision.
- **Notes are append-only.** Delete a note only after all of its claims are captured elsewhere and it no longer needs to be cited.
- **Decisions are not history.** They describe what is, not what was. History lives in notes.
- **Ideas are not decisions.** Keep speculative content out of `decisions/` until settled.
- **One concept per section.** Each section covers one decision point.
- **Cite everything.** Every decision section must link to the note(s) and idea(s), if any, that informed it.
- **Supersede explicitly.** When a note is superseded, add `> **Superseded — see [link].**` below its title and set `status: superseded` in frontmatter.
- **Skip superseded.** When scanning `notes/`, skip any file with a `Superseded` blockquote below its title.
- **Promote resolved guidance.** When notes or ideas resolve into guidance, update the relevant decision section and cite sources.
- **Close the loop on ideas.** When an idea is accepted, rejected, or superseded, update its `## Outcome`.

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

## Tags

- Search existing tags before inventing a new one.
- Reuse established tags; avoid case variants and near-synonyms.
- Keep tags short and topic-oriented.
