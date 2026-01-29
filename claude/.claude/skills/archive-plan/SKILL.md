---
name: archive-plan
description: Archive existing PLAN.md and tasks/ folder to .archive directory. Use before creating a new plan or to preserve completed plans.
---

# Archive Plan Workflow

## Purpose

Move existing `PLAN.md` and `tasks/` folder to `.archive/` directory at project root. Preserves plan history without cluttering the project.

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

1. Find project root by searching upward for markers (see detection order below)
2. If no marker found, ask user to confirm location - do not guess
3. Check if `PLAN.md` exists at project root
4. If not, inform user "Nothing to archive" and stop
5. Extract plan title from `PLAN.md` (first `# Plan: ...` heading)
6. Create archive folder at project root: `<project-root>/.archive/{date}_{title-slug}/`
7. Move `PLAN.md` to archive folder
8. Move `tasks/` folder to archive folder
9. Confirm: "Archived to .archive/{folder-name}/"

## Naming Convention

Archive folder: `{YYYY-MM-DD}_{title-slug}/`

- Date: Current date
- Title slug: Lowercase, hyphens, no special chars

Examples:
- `2025-01-29_user-authentication/`
- `2025-01-30_api-refactor/`
- `2025-02-01_fix-login-bug/`

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

## Rules

- ALWAYS create `.archive/` at project root - NEVER in subdirectories
- If no project root marker found, ask user to confirm location - do not guess
- Create `.archive/` directory if it doesn't exist
- Never overwrite existing archives - if slug exists, append `-2`, `-3`, etc.
- Preserve file permissions and timestamps
- If `tasks/` folder doesn't exist, archive only `PLAN.md`
- Add `.archive/` to `.gitignore` suggestion (inform user, don't modify)
