# Task: Implement JWT Service

## Status
<!-- TODO | IN PROGRESS | DONE -->
TODO

## Requires
- Task 02 must be complete

## Description
Create a JWT service for generating and validating access tokens and refresh tokens. Access tokens are short-lived (15min) for API requests. Refresh tokens are long-lived (7 days) and stored hashed in the database.

## Proposed Solution
Use `jsonwebtoken` package. Create `services/auth.js` with token generation and validation. Store refresh tokens as hashed values in the database to prevent token theft if DB is compromised.

## Subtasks
- [ ] Install jsonwebtoken package
- [ ] Create services/auth.js
- [ ] Implement generateAccessToken(user)
- [ ] Implement generateRefreshToken(user) with DB storage
- [ ] Implement verifyAccessToken(token)
- [ ] Implement verifyRefreshToken(token) with DB lookup
- [ ] Implement revokeRefreshToken(token)
- [ ] Add JWT_SECRET to environment config

## Files to Modify
- `package.json` - Add jsonwebtoken dependency
- `services/auth.js` - New file, JWT operations
- `.env.example` - Add JWT_SECRET placeholder

## Verification
- [ ] Tests pass: `npm test -- --grep "JWT service"`
- [ ] Builds without errors: `npm run build`
- [ ] Works as expected: Generate token, decode on jwt.io, verify claims

## Notes
<!-- Context for execution agent -->
