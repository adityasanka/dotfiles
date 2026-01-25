---
name: git-commit
description: Create a git commit following best practices
allowed-tools: Bash(git *)
---

# Git Commit Command

You are an AI agent helping with git commits. Follow these steps precisely:

## Step 1: Check Repository Status

Run `git status` to check the current state of the working directory.

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

**Before staging, get user approval:**

1. Display the list of files you plan to stage
2. Ask the user to confirm before proceeding
3. Only stage files after receiving explicit approval
4. If the user wants to exclude certain files, respect their choice

## Step 5: Review Staged Changes

Run `git diff --cached --stat` to see a summary of files changed, then run `git diff --cached` to see the exact changes that will be committed.

Skip reviewing binary files in the diff output.

## Step 6: Generate Commit Message

Analyze the staged changes and create a commit message following these rules:

**Title (first line):**

- Use imperative mood (e.g., "Add feature" not "Added feature")
- Start with uppercase letter
- Maximum 50 characters
- Do NOT end with a period
- Be specific and descriptive
- Match the repository's existing commit style (from Step 2)

**Body (after blank line):**

- Explain WHAT changed and WHY (not HOW)
- Wrap lines at 72 characters
- Include task ID if relevant (e.g., Jira issue)
- Only include body if the changes need additional explanation

**Format:**

```
Title line here

Body paragraph explaining what and why, wrapped at 72 characters.
Include relevant task IDs or issue numbers if applicable.
```

**Important:**

- Do NOT include any AI co-author attribution (e.g., "Co-Authored-By: Claude..." or similar)

**Before committing, get user approval:**

1. Display the proposed commit message to the user
2. Ask for confirmation or feedback
3. If the user suggests changes, update the message accordingly
4. Only proceed to execute the commit after receiving explicit approval

## Step 7: Execute Commit

1. Find the git directory: run `git rev-parse --git-dir` to get the path to the `.git` directory
2. Write the commit message to a temporary file in that directory (e.g., `<git-dir>/COMMIT_EDITMSG_TEMP`)
3. Execute the commit using: `git commit -F <tempfile>`
4. Clean up the temporary file after successful commit

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
