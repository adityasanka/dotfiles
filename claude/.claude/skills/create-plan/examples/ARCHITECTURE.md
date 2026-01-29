# Plan Architecture

This folder contains a complete example of the plan structure.

## Directory Layout

```
project-root/
├── PLAN.md                    # Entry point - high-level overview
└── tasks/                     # Individual task definitions
    ├── 01-setup-database.md
    ├── 02-create-user-model.md
    ├── 03-implement-jwt-service.md
    └── ...
```

## Why This Structure?

### PLAN.md (The Map)

- Quick overview of entire project
- Track overall progress at a glance
- Links to detailed task files
- Stays readable even with 20+ tasks

### Task Files (The Territory)

- Full implementation context per task
- Loaded one at a time during execution
- Self-contained = better AI focus
- Easy to retry failed tasks
- Natural git commit boundaries

## File Relationships

```
┌─────────────────────────────────────────────────────┐
│ PLAN.md                                             │
│                                                     │
│ ## Tasks                                            │
│ - [x] [01-setup-database](tasks/01-setup-db.md)    │──┐
│ - [ ] [02-create-user](tasks/02-create-user.md)    │──┼─► Individual
│ - [ ] [03-implement-jwt](tasks/03-jwt.md)          │──┤   Task Files
│ - [ ] [04-create-routes](tasks/04-routes.md)       │──┘
└─────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────┐
│ tasks/02-create-user-model.md                       │
│                                                     │
│ ## Status                                           │
│ TODO                     ◄── TODO | IN PROGRESS | DONE  │
│                                                     │
│ ## Requires                                         │
│ - Task 01 must be complete                          │
│                                                     │
│ ## Subtasks              ◄── Granular checkboxes    │
│ - [ ] Install bcrypt                                │
│ - [ ] Create User class                             │
│ - [ ] Implement create()                            │
│                                                     │
│ ## Verification          ◄── Must pass to complete  │
│ - [ ] Tests pass: `npm test`                        │
│ - [ ] Works as expected: [manual check]             │
└─────────────────────────────────────────────────────┘
```

## Benefits

| Benefit           | How                                              |
| ----------------- | ------------------------------------------------ |
| **Resumable**     | Checkboxes track progress; restart anytime       |
| **Focused**       | Load one task = smaller context = better results |
| **Auditable**     | Git commit per task = easy rollback              |
| **Collaborative** | Team members can own different tasks             |
| **Debuggable**    | Failed task? Fix that file, retry just that task |
