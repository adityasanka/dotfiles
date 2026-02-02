---
name: execute-plan
description: Execute implementation plans from PLAN.md, completing tasks sequentially with commits after each.
---

## Arguments

- `--batch-commit`: Defer commits until all tasks complete. Instead of committing after each task, invoke `/git-commit` once after the final summary.
- `--no-commit`: Skip commits entirely. No commit prompts appear during or after execution.

Default (no flag): commit after each task (current behavior).

## Dependencies

This skill requires:

- **`/git-commit` skill** - Required unless `--no-commit` is used. Located at `skills/git-commit/SKILL.md`.

If `/git-commit` is not available and commits are expected, inform the user and ask them to commit manually using standard git commands.

# Execute Plan Workflow

## Pre-Execution Checks

Before starting:

1. Check if `PLAN.md` exists at project root — if not, inform user "Nothing to execute - no PLAN.md found" and stop
2. Check for uncommitted changes — if found, warn user and ask to proceed or abort
3. Validate all task files exist (see Validate Task Files below)

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

## Progress Tracking Initialization

After pre-execution checks pass (and before executing the first task), initialize Claude Code's built-in task management for real-time UI feedback. Built-in tasks are a **display layer only** — the file-based system remains the source of truth.

1. Parse PLAN.md's `## Tasks` section — skip tasks already marked `[x]`
2. For each unchecked task, call `TaskCreate` with:
   - `subject`: Human-readable name (e.g., "Setup database")
   - `description`: Brief description from the PLAN.md line
   - `activeForm`: Present continuous form (e.g., "Setting up database")
3. Read each task file's `## Requires` field, then call `TaskUpdate` with `addBlockedBy` using the built-in task IDs of prerequisite tasks
4. Keep the mapping of plan task numbers → built-in task IDs in working memory

## Process

1. **Load plan**: Read PLAN.md, identify all tasks and their completion state
2. **Initialize progress tracking**: Create built-in tasks for unchecked entries and wire dependencies (see Progress Tracking Initialization above)
3. **Select task**: Identify first incomplete task (unchecked `- [ ]`)
4. **Check requires**: Read task file, verify `## Requires` dependencies are met
5. **Update status**: Set task file status to `IN PROGRESS`, then call `TaskUpdate` with `status: "in_progress"` for the corresponding built-in task ID
6. **Execute subtasks**: Complete each subtask, updating checkboxes and adding implementation notes to `## Notes`
7. **Verify**: Run verification steps from task file and update the checkboxes
8. **Mark complete**: Update task file status to `DONE`, check off in PLAN.md, then call `TaskUpdate` with `status: "completed"` for the corresponding built-in task ID
9. **Commit** (default mode only): Show summary, ask user "Ready to commit?", then invoke `/git-commit` skill
10. **Report**: Show task completion output
11. **Confirm continue**: Ask "Continue to next task? [Y/n]"
12. **Repeat**: If yes, move to next incomplete task
13. **Finish**: When all tasks complete (or user stops), show summary. If `--batch-commit`, prompt to commit all changes now.

## Execution Flow

```
Read PLAN.md → Init progress tracking → Find first unchecked task
         │
         ▼
Check ## Requires ── Not met ──► Stop, inform user
         │
         ▼ Met
IN PROGRESS → Execute subtasks → Run verification
         │                              │
         │                    Failed ──► Add to Notes, stop
         ▼ Passed
DONE, mark [x] in PLAN.md
         │
         ▼
[default mode only]
"Ready to commit?" ── No ──► User reviews ──┐
         │                                   │
         ▼ Yes                               │
Invoke /git-commit ◄────────────────────────┘
         │
         ▼
More tasks? ── No ──► Final summary ──► [--batch-commit: prompt to commit all]
         │
         ▼ Yes
"Continue?" ── No ──► Stop (resume later)
         │
         ▼ Yes
Next task (loop back)
```

## On Failure

- Do NOT mark task complete — keep status as `IN PROGRESS`
- Add failure details to task's `## Notes` section
- Stop execution and report failure to user
- User can fix issue and run `/execute-plan` to resume

## Task Completion Output

After each task (default mode):

```
✓ Task complete: 01-setup-database

Subtasks: 6/6 completed
Verification: All passed
Progress: 1/6 tasks (17%)
Commit: abc1234 - Setup PostgreSQL connection and create user schema

Continue to 02-create-user-model? [Y/n]
```

After each task (`--batch-commit` or `--no-commit`):

```
✓ Task complete: 01-setup-database

Subtasks: 6/6 completed
Verification: All passed
Progress: 1/6 tasks (17%)

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

If `--batch-commit`: After displaying the summary, ask "Ready to commit all changes?" and invoke `/git-commit` once approved. Include the commit hash in the summary output.

## Verification Handling

- **Automated checks**: Run command, must exit 0 to pass
- **Manual checks**: Ask user to confirm before marking complete
- **Timeouts**: If `(timeout: Xmin)` is specified, abort command after that duration
  - Default: 5 minutes for tests, 2 minutes for builds
  - If command times out, treat as failure and inform user
- If any verification fails, do not mark task complete

## Resume Capability

When resuming interrupted work:

1. Read PLAN.md, find first unchecked task
2. Run Progress Tracking Initialization — creates built-in tasks for unchecked entries only (built-in tasks are session-scoped, so previous session's tasks don't persist)
3. If first unchecked task has file status `IN PROGRESS`, set its built-in task to `in_progress`
4. Review subtask checkboxes to find where to resume, continue from first incomplete subtask
5. Follow normal Process flow

Commit mode does not persist across sessions. When resuming, the default commit behavior applies unless the user passes `--batch-commit` or `--no-commit` again.

## Commands

| User Says                      | Action                                                                          |
| ------------------------------ | ------------------------------------------------------------------------------- |
| `/execute-plan`                | Start from first incomplete task, commit after each                             |
| `/execute-plan --batch-commit` | Execute all tasks, commit once at the end                                       |
| `/execute-plan --no-commit`    | Execute all tasks, skip commits entirely                                        |
| "continue the plan"            | Same as execute (resume-aware)                                                  |
| "execute task 03"              | Execute specific task only                                                      |
| "skip task 02"                 | Set status to SKIPPED, mark `[x]` in PLAN.md, add reason to Notes, move to next |
| "stop after this task"         | Complete current, then stop                                                     |
