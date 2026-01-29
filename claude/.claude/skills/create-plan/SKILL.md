---
name: create-plan
description: Create PLAN.md + tasks/ folder with implementation plan. Does NOT execute - use execute-plan to run.
---

# Create Plan Workflow

## Output Structure

Always create at **project root**:

```
<project-root>/
├── PLAN.md                      # High-level overview + task checklist
└── tasks/
    ├── 01-task-name.md          # Individual task with full details
    ├── 02-another-task.md
    └── ...
```

See `examples/` folder for complete reference implementation.

## Project Root Detection

Search upward from current directory for these markers (in priority order):

1. `.git/` - Git repository
2. `go.mod` - Go modules
3. `package.json` - Node.js/npm
4. `Cargo.toml` - Rust
5. `pyproject.toml` - Python
6. `pom.xml` - Java/Maven
7. `Makefile` - C/C++/general

Stop at the first match. If no marker is found, ask the user to specify the project root.

## If PLAN.md Already Exists

Before creating a new plan, check if `PLAN.md` exists at project root.

If it exists, inform the user and offer two options:

1. **Cancel** - Stop and let user handle manually
2. **Archive and continue** - Run `/archive-plan` to archive existing plan, then proceed

Example prompt:

```
PLAN.md already exists at {{path}}.
1. Cancel
2. Archive existing plan and continue
```

If user selects Archive, invoke `/archive-plan` skill first, then continue with plan creation.

## Before Creating the Plan

1. Understand the existing codebase structure
2. Identify existing patterns to follow
3. Ask clarifying questions if scope is ambiguous
4. Confirm tech stack choices with user if multiple options exist

## Process

1. Analyze the request and break into discrete tasks
2. Create `PLAN.md` using template structure
3. Create `tasks/` directory
4. Create numbered task files (01-, 02-, etc.)
5. Link tasks in PLAN.md checklist
6. Stop and present plan for review

## Success Output

After creating the plan, display this format:

```
✓ Plan created: {Plan Title} ({N} tasks)

Location: {project-root-path}/

PLAN.md
tasks/
├── 01-first-task.md
├── 02-second-task.md
├── 03-third-task.md
└── ...

📋 Copied PLAN.md path to clipboard

Run /execute-plan to start implementation.
```

Rules for success output:

- Show all tasks if 10 or fewer
- If more than 10 tasks, show first 9 then `└── ... ({N} more)`
- Copy full path of PLAN.md to clipboard using `pbcopy` (macOS) or equivalent
- Always end with the `/execute-plan` hint

Example with truncation (12 tasks):

```
✓ Plan created: User Authentication (12 tasks)

Location: /Users/dev/my-project/

PLAN.md
tasks/
├── 01-setup-database.md
├── 02-create-user-model.md
├── 03-implement-jwt-service.md
├── 04-create-auth-routes.md
├── 05-add-middleware.md
├── 06-write-tests.md
├── 07-add-rate-limiting.md
├── 08-create-password-reset.md
├── 09-add-email-verification.md
└── ... (3 more)

📋 Copied PLAN.md path to clipboard

Run /execute-plan to start implementation.
```

## PLAN.md Structure

```markdown
# Plan: [Title]

## Problem

[What problem are we solving? 2-3 sentences]

## Solution

[High-level approach. Key architectural decisions. 1-2 paragraphs max]

## Tasks

<!-- Tasks are numbered in execution order. Each task depends on all previous tasks being complete. -->

- [ ] [01-task-name](tasks/01-task-name.md) - Brief description
- [ ] [02-task-name](tasks/02-task-name.md) - Brief description

## Dependencies

[External dependencies, prerequisites, or blockers]

## Notes

[Important context, constraints, or decisions]
```

## Task File Structure

Each `tasks/NN-task-name.md`:

```markdown
# Task: [Descriptive Name]

## Status

<!-- TODO | IN PROGRESS | DONE | SKIPPED -->
<!-- Detailed state here; PLAN.md checkbox is source of truth for completion -->

TODO

## Requires

- Task NN must be complete (or "None" if first task)

## Description

[What this task accomplishes. 2-3 sentences.]

## Proposed Solution

[Technical approach. Key implementation details.]

## Subtasks

- [ ] Subtask 1
- [ ] Subtask 2
- [ ] Subtask 3

## Files to Modify

- `path/to/file.py` - [what changes]
- `path/to/other.js` - [what changes]

## Verification

- [ ] Tests pass: `command to run tests` (timeout: 5min)
- [ ] Builds without errors: `build command` (timeout: 2min)
- [ ] Works as expected: [manual verification step]

## Notes

<!-- Context for execution agent -->
```

## Rules

- If requirements are unclear, ask clarifying questions BEFORE creating the plan
- Do not make assumptions about tech stack, patterns, or scope
- Tasks must be atomic and independently executable
- Number tasks in logical execution order (01-, 02-, etc.)
- Keep task descriptions actionable and specific
- Each task should be completable in one session
- If you can't describe what "done" looks like in one sentence, it's too big
- Include verification steps for every task
- Never execute code - only create the plan structure
- Wait for user approval before considering plan complete
