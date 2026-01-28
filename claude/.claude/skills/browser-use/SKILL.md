---
name: browser-use
description: Browser automation using Agent-Browser (default) with Playwright MCP fallback
allowed-tools: Bash(agent-browser *), mcp__playwright__*
---

# Browser Automation Skill

You are an AI agent helping with browser automation tasks. This skill provides guidelines for choosing the right tool based on the scenario.

## Display Mode

**Default: Headed mode (visible browser window)**

Always run browser automation in headed mode so the user can observe the actions being performed. This builds trust and aids debugging.

- **Agent-Browser**: Add `--headed` flag to all commands (it defaults to headless)
- **Playwright MCP**: Already defaults to headed mode (no flag needed)

**Exception: Headless mode**

Only run in headless mode if:

1. The user passes `--headless` flag to this skill
2. The user explicitly mentions "headless" in their request

When headless mode is requested:

- **Agent-Browser**: Omit the `--headed` flag
- **Playwright MCP**: The server must be configured with `--headless` arg

## Available Tools

### 1. Agent-Browser (Default)

A CLI tool optimized for AI agents with 93% less context usage than traditional browser automation.

**Use Agent-Browser for:**

- Simple navigation and page loading
- Extracting text, HTML, or element values
- Clicking buttons and links
- Filling forms and typing text
- Taking screenshots
- Basic element interaction (hover, focus, check/uncheck)
- Long autonomous browsing sessions where context budget matters

**Commands:**

```bash
# Navigation (always include --headed for visible browser)
agent-browser --headed open <url>
agent-browser --headed back | forward | reload

# Get page state (AI-optimized)
agent-browser --headed snapshot         # Full accessibility tree with refs
agent-browser --headed snapshot -i      # Interactive elements only
agent-browser --headed snapshot -c      # Compact mode

# Interaction (use @ref from snapshot)
agent-browser --headed click @e1
agent-browser --headed fill @e2 "text"
agent-browser --headed type @e3 "text"
agent-browser --headed press Enter

# Extraction
agent-browser --headed text @e1
agent-browser --headed html @e1
agent-browser --headed value @e1

# Screenshots
agent-browser --headed screenshot
agent-browser --headed screenshot @e1   # Element screenshot
```

### 2. Playwright MCP (Fallback)

A full-featured browser automation MCP server. Use when Agent-Browser cannot accomplish the task.

**Use Playwright MCP for:**

- PDF generation
- Vision/coordinate-based interactions
- Multi-tab orchestration
- Network interception and mocking
- Complex waiting conditions
- Browser extension testing
- When Agent-Browser commands fail

**Tools available via MCP:**

- `mcp__playwright__browser_navigate`
- `mcp__playwright__browser_screenshot`
- `mcp__playwright__browser_click`
- `mcp__playwright__browser_type`
- `mcp__playwright__browser_select_option`
- `mcp__playwright__browser_pdf_save`
- `mcp__playwright__browser_network_requests`
- And more...

## Decision Tree

```
Is this task about PDF generation?
  └─ YES → Use Playwright MCP (browser_pdf_save)
  └─ NO ↓

Does it require vision/coordinate-based interaction?
  └─ YES → Use Playwright MCP with vision mode
  └─ NO ↓

Does it need multi-tab orchestration?
  └─ YES → Use Playwright MCP
  └─ NO ↓

Does it need network interception/mocking?
  └─ YES → Use Playwright MCP
  └─ NO ↓

Is this a simple navigation, extraction, or form task?
  └─ YES → Use Agent-Browser (default)
  └─ NO ↓

Did Agent-Browser command fail?
  └─ YES → Retry with Playwright MCP
  └─ NO → Use Agent-Browser
```

## Workflow

### Step 1: Assess the Task

Before starting, determine which tool is appropriate based on the decision tree above.

### Step 2: Start with Agent-Browser (if applicable)

For most tasks, begin with Agent-Browser (always use `--headed` for visible browser):

```bash
# Open the page (headed mode)
agent-browser --headed open "https://example.com"

# Get interactive elements
agent-browser --headed snapshot -i

# Interact using refs from snapshot
agent-browser --headed click @e3
agent-browser --headed fill @e5 "search query"
```

### Step 3: Fall Back to Playwright MCP (if needed)

If Agent-Browser cannot complete the task or encounters errors:

1. Note the limitation encountered
2. Switch to Playwright MCP tools
3. Use the appropriate MCP tool for the task

### Step 4: Report Results

After completing the browser automation:

1. Summarize what was accomplished
2. Include any extracted data or screenshots
3. Note if fallback to Playwright MCP was required and why

### Step 5: Cleanup

After **all** actions are complete and results have been reported to the user, close the browser:

- **Agent-Browser**: `agent-browser close`
- **Playwright MCP**: `mcp__playwright__browser_close`

**Important**: Do NOT close the browser between actions. Keep it open throughout the entire task to:

- Preserve session state (cookies, authentication, scroll position)
- Avoid unnecessary latency from repeated open/close cycles
- Allow the user to observe the full automation sequence

Only close the browser once at the very end when the task is fully complete.

## Examples

### Example 1: Simple Page Scraping (Agent-Browser)

```bash
agent-browser --headed open "https://news.ycombinator.com"
agent-browser --headed snapshot -i -c
agent-browser --headed text @e1  # Extract headline text
# ... report results to user ...
agent-browser close              # Cleanup: close browser when done
```

### Example 2: Generate PDF (Playwright MCP)

Use `mcp__playwright__browser_navigate` to open the page, then `mcp__playwright__browser_pdf_save` to generate the PDF. After reporting results, use `mcp__playwright__browser_close` to close the browser.

### Example 3: Fill and Submit Form (Agent-Browser)

```bash
agent-browser --headed open "https://example.com/login"
agent-browser --headed snapshot -i
agent-browser --headed fill @username "user@example.com"
agent-browser --headed fill @password "secretpassword"
agent-browser --headed click @submit
agent-browser --headed snapshot  # Verify result
# ... report results to user ...
agent-browser close              # Cleanup: close browser when done
```

## Notes

- **Always use `--headed` flag** with Agent-Browser for visible browser (unless `--headless` requested)
- Agent-Browser maintains session state between commands
- Use `agent-browser --headed snapshot -i` for a focused view of interactive elements
- Playwright MCP requires the MCP server to be configured in the project
- Both tools use Chromium by default
