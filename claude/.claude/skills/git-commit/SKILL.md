---
name: git-commit
description: Create a git commit following best practices
allowed-tools: Bash(git *)
---

# Git Commit Command

## Arguments

- `--auto`: Skip all user approval prompts. Stage files and commit without asking
  for confirmation. Security safeguards (no staging of .env, secrets, binaries) still
  apply. When not set, display proposed changes and ask for user confirmation at each
  approval point (staging and commit message).

## Step 1: Check Repository Status

Run `git status`.

## Step 2: Review Recent Commit History

Run `git log --oneline -5` to see recent commit message patterns.
Match the repository's existing style when writing your commit message.

## Step 3: Detect Changes

- Check if there are any staged or unstaged changes
- If NO changes exist (clean working directory), respond politely:
  "Your working directory is clean. There's nothing to commit at the moment."
  Then EXIT without proceeding further.

## Step 4: Handle Staging

- If there are ALREADY staged files:
  - Keep them as-is (the user has handpicked these changes)
  - Do NOT stage any additional files
- If there are NO staged files but there ARE unstaged changes:
  - Review the list of changed files carefully
  - NEVER stage files that may contain secrets: `.env`, `*.key`, `credentials.*`, `*.pem`, `*.secret`
  - NEVER stage binary files
  - If suspicious files are detected, warn the user and skip them

If `--auto` is not set, display the list of files you plan to stage and ask the user to confirm. Respect any exclusions they request.

## Step 5: Review Staged Changes

Run `git diff --cached --stat` then `git diff --cached` to review what will be committed.

## Step 6: Generate Commit Message

Analyze the staged changes and create a commit message following these rules:

**Title (first line):**

- Use imperative mood (e.g., "Add feature" not "Added feature")
- Start with uppercase letter
- Maximum 50 characters
- Do NOT end with a period
- Be specific and descriptive

**Body (after blank line):**

- Explain WHAT changed and WHY (not HOW)
- Wrap lines at 72 characters
- Include task ID if relevant (e.g., Jira issue)
- Only include body if the changes need additional explanation

**Important:**

- Do NOT include any AI co-author attribution (e.g., "Co-Authored-By: Claude..." or similar)

If `--auto` is not set, display the proposed commit message and ask for confirmation. Update the message if the user suggests changes.

## Step 7: Execute Commit

Execute the commit by piping the message via stdin heredoc:

```bash
git commit -F - <<'EOF'
<commit message here>
EOF
```

**If the commit fails due to pre-commit hooks:**

1. Display the hook error output to the user
2. Explain what the errors mean
3. Do NOT automatically fix the issues - let the user decide how to proceed
4. Remind the user to run `/git-commit` again after they've resolved the issues

## Step 8: Confirm

Run this command to get the commit summary:

```bash
git log -1 --stat --format="Committed: %h%n%nMessage:%n%B"
```

**Important:**

- Include the full output in your text response to the user.
- Do not just show the tool output - copy the commit hash, message, and file stats into your final message so the user sees it directly.
