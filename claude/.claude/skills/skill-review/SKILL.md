---
name: skill-review
description: Systematic review of custom skill definitions against repo conventions and quality criteria
---

# Skill Review

Review a skill's SKILL.md against structure, conciseness, and workflow quality criteria. This skill reports findings but does not modify SKILL.md files.

## Arguments

- Optional: skill name (e.g., `git-commit`). If omitted, list available skills and ask which to review.

## Step 1: Locate the Skill

If a skill name was provided as an argument:

1. Read `.claude/skills/<name>/SKILL.md` (paths are relative to the project root)
2. If it doesn't exist, report the error and list available skills

If no argument was provided:

1. List directories under `.claude/skills/`
2. Ask the user which skill to review

## Step 2: Evaluate

Read the SKILL.md and evaluate against the three tiers below. For each criterion, assign one of:

- **Pass** — meets the criterion
- **Warning** — minor issue, works but could improve
- **Issue** — fails the criterion, should be fixed

### Tier 1 — Structure

| Criterion                         | Description                                             |
| --------------------------------- | ------------------------------------------------------- |
| Frontmatter `name`                | YAML frontmatter contains `name` field                  |
| Frontmatter `description`         | YAML frontmatter contains `description` field           |
| `allowed-tools` present if needed | Has `allowed-tools` if the skill uses Bash or MCP tools |
| Directory matches name            | Directory name matches frontmatter `name`               |
| Description is concise            | `description` is a single, concise sentence             |

### Tier 2 — Conciseness

| Criterion                   | Description                                                     |
| --------------------------- | --------------------------------------------------------------- |
| No repeated instructions    | Same directive does not appear in multiple places               |
| No low-signal padding       | No generic advice that wouldn't change behavior if removed      |
| No unnecessary hedging      | Avoids filler phrases like "make sure to", "always remember to" |
| No redundant examples       | Examples add clarity beyond what the prose already explains     |
| Nothing stating the obvious | Does not instruct default or automatic behavior                 |

### Tier 3 — Workflow Quality

| Criterion          | Description                                                 |
| ------------------ | ----------------------------------------------------------- |
| Clear entry point  | Documents what triggers the skill and what input it expects |
| Step ordering      | Logical sequence with dependencies reflected in order       |
| Exit conditions    | Defines what "done" looks like                              |
| Error/edge cases   | Handles likely failure modes                                |
| Scope boundaries   | Clear about what the skill does not do                      |
| Integration points | References to other skills or tools are correct             |

## Step 3: Report & Discuss

Present results as a summary table:

```
## Review: <skill-name>

| #  | Criterion                  | Tier | Result  |
|----|----------------------------|------|---------|
| 1  | Frontmatter `name`         | 1    | Pass    |
| 2  | Frontmatter `description`  | 1    | Pass    |
| ...| ...                        | ...  | ...     |
```

Only include rows with Warning or Issue results, plus a count of passing criteria:

```
N of M criteria passed. Details on findings below.
```

Then for each Warning or Issue, provide:

- The criterion name and tier
- What was found
- A specific suggestion to fix it

After presenting the report, discuss findings with the user and iterate if they want to adjust anything. The skill is complete when the user acknowledges the review or no further changes are requested.
