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

## Progress Tracking Initialization

After pre-execution checks pass (and before executing the first task), initialize Claude Code's built-in task management for real-time UI feedback. Built-in tasks are a **display layer only** — the file-based system remains the source of truth.

1. Parse PLAN.md's `## Tasks` section for all task entries
2. For each **unchecked** (`- [ ]`) task entry:
   - Extract the task name and brief description from the line (e.g., from `- [ ] [01-setup-database](tasks/01-setup-database.md) - Configure PostgreSQL and create user schema`, extract name "Setup database" and description "Configure PostgreSQL and create user schema")
   - Call `TaskCreate` with:
     - `subject`: Human-readable task name (e.g., "Setup database")
     - `description`: The brief description from PLAN.md
     - `activeForm`: Present continuous form of the task name (e.g., "Setting up database"). This powers the spinner text in the UI.
   - Remember the returned task ID — you'll need it for status updates later
3. Skip tasks already marked `[x]` in PLAN.md — do not create built-in tasks for them
4. After all built-in tasks are created, read each corresponding task file's `## Requires` field. For tasks that depend on other tasks, call `TaskUpdate` with `addBlockedBy` using the built-in task IDs of the prerequisite tasks
5. Keep the mapping of plan task numbers → built-in task IDs in working memory for the session

Example: For a plan with 3 unchecked tasks where task 02 requires 01 and task 03 requires 02:
- `TaskCreate` for each → returns IDs #1, #2, #3
- `TaskUpdate(#2, addBlockedBy: [#1])`
- `TaskUpdate(#3, addBlockedBy: [#2])`

## Process

1. **Load plan**: Read PLAN.md, identify all tasks and their completion state
2. **Initialize progress tracking**: Create built-in tasks for unchecked entries and wire dependencies (see Progress Tracking Initialization above)
3. **Select task**: Identify first incomplete task (unchecked `- [ ]`)
4. **Check requires**: Read task file, verify `## Requires` dependencies are met
5. **Update status**: Set task file status to `IN PROGRESS`, then call `TaskUpdate` with `status: "in_progress"` for the corresponding built-in task ID
6. **Execute subtasks**: Complete each subtask, updating checkboxes as you go
7. **Verify**: Run verification steps from task file
8. **Mark complete**: Update task file status to `DONE`, check off in PLAN.md, then call `TaskUpdate` with `status: "completed"` for the corresponding built-in task ID
9. **Request approval**: Show summary, ask user "Ready to commit?"
10. **Commit**: Once approved, invoke `/git-commit` skill
11. **Report**: Show task completion output
12. **Confirm continue**: Ask "Continue to next task? [Y/n]"
13. **Repeat**: If yes, move to next incomplete task
14. **Finish**: When all tasks complete (or user stops), show summary

## Execution Flow

```
Read PLAN.md
         │
         ▼
Initialize progress tracking
(TaskCreate for each unchecked task,
 wire blockedBy dependencies)
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

Three status indicators are maintained for each task:

| Location | Format | Purpose |
|----------|--------|---------|
| PLAN.md | `- [ ]` / `- [x]` | **Source of truth** for completion. Quick overview. |
| Task file | `## Status` section | Detailed state: TODO, IN PROGRESS, DONE, SKIPPED |
| Built-in task | `TaskUpdate` status | Real-time UI feedback (spinner/progress). Session-scoped. |

Keep all three in sync:
- When starting a task: Set task file status to `IN PROGRESS`
- When completing: Set task file status to `DONE`, then mark `[x]` in PLAN.md
- When skipping: Set task file status to `SKIPPED`, mark `[x]` in PLAN.md, add reason to Notes
- PLAN.md checkbox determines whether a task is skipped during execution

## During Execution

- Work on ONE task at a time
- Update subtask checkboxes as each completes
- Add implementation notes to task's `## Notes` section
- Keep built-in task status in sync: update file-based status first, then call `TaskUpdate` to match
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
- Keep built-in task status as `in_progress` (no change needed — matches file-based behavior)
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
2. Run Progress Tracking Initialization — this creates built-in tasks only for unchecked `- [ ]` entries, so already-completed tasks are automatically excluded
3. Read task file - check if status is `IN PROGRESS` (partial work)
4. If task is `IN PROGRESS` (partial work from previous session), immediately call `TaskUpdate` to set its built-in task to `in_progress`
5. If partial, review subtask checkboxes to find where to resume
6. Continue from first incomplete subtask
7. Follow normal execution flow

### Progress Tracking on Resume

Built-in tasks are session-scoped — they don't persist across sessions. On resume:

- **Initialization recreates them**: The Progress Tracking Initialization phase (step 2) creates built-in tasks for all remaining incomplete work
- **In-progress tasks need immediate update**: If the first unchecked task has file status `IN PROGRESS` (started in a previous session), set its built-in task to `in_progress` before resuming subtask execution
- **Prior completed tasks won't appear in UI**: Tasks completed in previous sessions are already `[x]` in PLAN.md, so no built-in tasks are created for them. This is expected — the UI shows current session progress only

## Commands

| User Says | Action |
|-----------|--------|
| `/execute-plan` | Start from first incomplete task |
| "continue the plan" | Same as execute (resume-aware) |
| "execute task 03" | Execute specific task only |
| "skip task 02" | Set status to SKIPPED, mark `[x]` in PLAN.md, add reason to Notes, move to next |
| "stop after this task" | Complete current, then stop |

## Safety

- Never skip verification steps
- Always commit after successful task completion (via /git-commit)
- Stop on first failure rather than continuing
- Warn user about uncommitted changes before starting (don't auto-stash)
