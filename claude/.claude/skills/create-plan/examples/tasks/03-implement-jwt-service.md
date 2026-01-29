# Task: Implement JWT Service

## Status
<!-- TODO | IN PROGRESS | DONE | SKIPPED -->
IN PROGRESS

## Requires
- Task 02 must be complete

## Description
Create a JWT service for generating and validating access tokens and refresh tokens. Access tokens are short-lived (15min) for API requests. Refresh tokens are long-lived (7 days) and stored hashed in the database.

## Proposed Solution
Use `jsonwebtoken` package. Create `services/auth.js` with token generation and validation. Store refresh tokens as hashed values in the database to prevent token theft if DB is compromised.

## Subtasks
- [x] Install jsonwebtoken package
- [x] Create services/auth.js
- [x] Implement generateAccessToken(user)
- [x] Implement generateRefreshToken(user) with DB storage
- [ ] Implement verifyAccessToken(token)
- [ ] Implement verifyRefreshToken(token) with DB lookup
- [ ] Implement revokeRefreshToken(token)
- [ ] Add JWT_SECRET to environment config

## Files to Modify
- `package.json` - Add jsonwebtoken dependency
- `services/auth.js` - New file, JWT operations
- `.env.example` - Add JWT_SECRET placeholder

## Verification
- [ ] Tests pass: `npm test -- --grep "JWT service"` (timeout: 5min)
- [ ] Builds without errors: `npm run build` (timeout: 2min)
- [ ] Works as expected: Generate token, decode on jwt.io, verify claims

## Notes
<!-- Blocker details added during execution -->
**BLOCKED**: Tests failing with "JWT_SECRET is not defined" error.

**What happened:**
- Completed token generation functions (subtasks 1-4)
- Tests fail because JWT_SECRET env var is not set in test environment
- `.env.example` was updated but `.env.test` was not created

**To unblock:**
1. Create `.env.test` with test-specific JWT_SECRET value
2. Update `jest.config.js` to load `.env.test` before running tests
3. Re-run `/execute-plan` to continue from verification step

**Attempted fixes:**
- Tried hardcoding secret in tests (bad practice, reverted)
- Looked for existing env loading pattern but none found in codebase
