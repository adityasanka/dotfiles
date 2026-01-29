---
name: execute-plan
description: Execute implementation plans created by create-plan skill. Reads PLAN.md, executes tasks one at a time, updates status, and commits via /git-commit.
---

## Dependencies

This skill requires:

- **`/git-commit` skill** - Must be available for automatic commits after each task. Located at `skills/git-commit/SKILL.md`.

If `/git-commit` is not available, inform the user and ask them to commit manually using standard git commands.

# Execute Plan Workflow

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

## Pre-Execution Checks

Before starting:

1. Find project root using detection above
2. Check if `PLAN.md` exists at project root
3. If not, inform user "Nothing to execute - no PLAN.md found" and stop
4. Check for uncommitted changes - if found, warn user and ask to proceed or abort
5. Validate all task files exist (see Validate Task Files below)

## Validate Task Files

Parse PLAN.md and verify each linked task file exists before starting execution.

If any files are missing, display:

```
Missing task files:
- tasks/03-implement-jwt-service.md (referenced in PLAN.md)
- tasks/05-add-middleware.md (referenced in PLAN.md)

Please create missing files or update PLAN.md before continuing.
```

Stop execution and let user fix issues before proceeding.

## Process

1. **Load plan**: Read PLAN.md, identify first incomplete task (unchecked `- [ ]`)
2. **Check requires**: Read task file, verify `## Requires` dependencies are met
3. **Update status**: Set task status to `IN PROGRESS`
4. **Execute subtasks**: Complete each subtask, updating checkboxes as you go
5. **Verify**: Run verification steps from task file
6. **Mark complete**: Update task status to `DONE`, check off in PLAN.md
7. **Request approval**: Show summary, ask user "Ready to commit?"
8. **Commit**: Once approved, invoke `/git-commit` skill
9. **Report**: Show task completion output
10. **Confirm continue**: Ask "Continue to next task? [Y/n]"
11. **Repeat**: If yes, move to next incomplete task
12. **Finish**: When all tasks complete (or user stops), show summary

## Execution Flow

```
Read PLAN.md
         │
         ▼
Find first unchecked task
         │
         ▼
Check ## Requires dependencies
         │
         ├── Not met ──► Stop, inform user
         │
         ▼ Met
Set status: IN PROGRESS
         │
         ▼
Execute subtasks (update checkboxes)
         │
         ▼
Run verification steps
         │
         ├── Failed ──► Add to Notes, stop, inform user
         │
         ▼ Passed
Set status: DONE
Mark [x] in PLAN.md
         │
         ▼
"Ready to commit?" ◄───────────────┐
         │                         │
         ├── No ──► User reviews ──┘
         │
         ▼ Yes
Invoke /git-commit
         │
         ▼
Show task completion output
         │
         ▼
More tasks? ──No──► Show final summary
         │
         ▼ Yes
"Continue to next task? [Y/n]"
         │
         ├── No ──► Stop (resume later)
         │
         ▼ Yes
Next task (loop back to top)
```

## Task Selection

- Always execute tasks in order (01, 02, 03...)
- Skip tasks already marked `[x]` in PLAN.md
- Before starting a task, verify its `## Requires` dependencies are complete
- If dependencies not met, inform user and stop

## Status Tracking

Two status indicators are maintained for each task:

| Location | Format | Purpose |
|----------|--------|---------|
| PLAN.md | `- [ ]` / `- [x]` | **Source of truth** for completion. Quick overview. |
| Task file | `## Status` section | Detailed state: TODO, IN PROGRESS, DONE, SKIPPED |

Keep both in sync:
- When starting a task: Set task file status to `IN PROGRESS`
- When completing: Set task file status to `DONE`, then mark `[x]` in PLAN.md
- PLAN.md checkbox determines whether a task is skipped during execution

## During Execution

- Work on ONE task at a time
- Update subtask checkboxes as each completes
- Add implementation notes to task's `## Notes` section
- If blocked, add details to Notes, stop, and inform user

## After Each Task

1. Run all verification steps
2. Update task file: `## Status` → `DONE`
3. Update PLAN.md: `- [ ]` → `- [x]`
4. Show summary and ask: "Ready to commit? (yes/no)"
   - If no: Pause, let user review/modify, ask again when ready
   - If yes: Proceed to commit
5. Invoke `/git-commit` skill (it handles commit message format)
   - If `/git-commit` unavailable, inform user to commit manually
6. Display task completion output
7. Ask: "Continue to next task? [Y/n]"
   - Enter or Y: Proceed to next task
   - n: Stop execution, user can resume later with `/execute-plan`

## On Failure

- Do NOT mark task complete
- Add failure details to task's `## Notes` section
- Keep status as `IN PROGRESS`
- Stop execution and report failure to user
- User can fix issue and run `/execute-plan` to resume

## Task Completion Output

After each task:

```
✓ Task complete: 01-setup-database

Subtasks: 6/6 completed
Verification: All passed
Progress: 1/6 tasks (17%)
Commit: abc1234 - Setup PostgreSQL connection and create user schema

Continue to 02-create-user-model? [Y/n]
```

- **Enter** or **Y** → Continue to next task (default)
- **n** → Stop here, resume later with `/execute-plan`

## Final Summary Output

When all tasks complete:

```
✓ Plan complete: User Authentication

Tasks: 6/6 completed (100%)
─────────────────────────
[x] 01-setup-database
[x] 02-create-user-model
[x] 03-implement-jwt-service
[x] 04-create-auth-routes
[x] 05-add-middleware
[x] 06-write-tests

Run /archive-plan to archive this plan.
```

## Verification Handling

- **Automated checks**: Run command, must exit 0 to pass
- **Manual checks**: Ask user to confirm before marking complete
- **Timeouts**: If `(timeout: Xmin)` is specified, abort command after that duration
  - Default: 5 minutes for tests, 2 minutes for builds
  - If command times out, treat as failure and inform user
- If any verification fails, do not mark task complete

## Resume Capability

When resuming interrupted work:

1. Read PLAN.md to find first unchecked task
2. Read task file - check if status is `IN PROGRESS` (partial work)
3. If partial, review subtask checkboxes to find where to resume
4. Continue from first incomplete subtask
5. Follow normal execution flow

## Commands

| User Says | Action |
|-----------|--------|
| `/execute-plan` | Start from first incomplete task |
| "continue the plan" | Same as execute (resume-aware) |
| "execute task 03" | Execute specific task only |
| "skip task 02" | Mark task skipped in Notes, move to next |
| "stop after this task" | Complete current, then stop |

## Safety

- Never skip verification steps
- Always commit after successful task completion (via /git-commit)
- Stop on first failure rather than continuing
- Warn user about uncommitted changes before starting (don't auto-stash)
