---
name: archive-plan
description: Archive existing PLAN.md and tasks/ folder to .archive directory.
allowed-tools:
  - Bash
---

# Archive Plan Workflow

## Input

Takes no arguments. Operates on `PLAN.md` at project root.

## Output Structure

```
<project-root>/
├── .archive/
│   ├── 2025-01-29_user-auth/
│   │   ├── PLAN.md
│   │   └── tasks/
│   │       ├── 01-setup-database.md
│   │       └── ...
│   └── 2025-01-30_api-refactor/
│       ├── PLAN.md
│       └── tasks/
├── PLAN.md        ← (removed after archive)
└── tasks/         ← (removed after archive)
```

## Process

1. Find project root (nearest `.git/`, `package.json`, `Cargo.toml`, etc.) — if none found, ask user
2. Check if `PLAN.md` exists at project root
3. If not, inform user "Nothing to archive" and stop
4. Extract plan title from `PLAN.md` (first `# Plan: ...` heading)
5. Create archive folder at project root: `<project-root>/.archive/{date}_{title-slug}/`
6. Copy and remove files atomically (see Atomic Operations below)
7. Display success message:
   ```
   ✓ Archived: {Plan Title}

   Location: .archive/{folder-name}/
   ```

## Atomic Operations

To prevent partial state if interrupted, use copy-then-delete:

1. **Copy phase** (all or nothing):
   ```bash
   cp PLAN.md {archive-folder}/PLAN.md
   cp -r tasks/ {archive-folder}/tasks/
   ```

2. **Verify copies exist** before proceeding

3. **Delete phase** (only after successful copy):
   ```bash
   rm PLAN.md
   rm -r tasks/
   ```

**Error recovery:**
- If copy fails: Remove any partial copies from archive folder, inform user
- If delete fails: Archive is complete but originals remain - inform user to delete manually

## Naming Convention

Archive folder: `{YYYY-MM-DD}_{title-slug}/`

- Date: Current date
- Title slug: Lowercase, hyphens, no special chars
- Example: `2025-01-29_user-authentication/`

## Rules

- Never overwrite existing archives - if slug exists, append `-2`, `-3`, etc.
- If `tasks/` folder doesn't exist, archive only `PLAN.md`
- Add `.archive/` to `.gitignore` suggestion (inform user, don't modify)
