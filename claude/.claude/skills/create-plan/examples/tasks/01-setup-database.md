# Task: Setup Database

## Status
<!-- TODO | IN PROGRESS | DONE -->
TODO

## Requires
None (first task)

## Description
Configure PostgreSQL connection with connection pooling and create the initial database schema for user authentication. This establishes the data layer foundation for all subsequent tasks.

## Proposed Solution
Use `pg` package with a connection pool. Create a `db/` module that exports query helpers. Schema includes users table with fields for email, password hash, timestamps, and refresh token tracking.

```sql
-- Core users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Refresh tokens for session management
CREATE TABLE refresh_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  token_hash VARCHAR(255) NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## Subtasks
- [ ] Install pg package
- [ ] Create db/config.js with connection pool
- [ ] Create db/index.js with query helpers
- [ ] Write migration file for users table
- [ ] Write migration file for refresh_tokens table
- [ ] Run migrations and verify tables exist

## Files to Modify
- `package.json` - Add pg dependency
- `db/config.js` - New file, connection configuration
- `db/index.js` - New file, query helpers
- `db/migrations/001_users.sql` - New file, users table
- `db/migrations/002_refresh_tokens.sql` - New file, tokens table

## Verification
- [ ] Tests pass: `npm test -- --grep "database"`
- [ ] Builds without errors: `npm run build`
- [ ] Works as expected: Connect with psql and verify tables exist with `\dt`

## Notes
<!-- Context for execution agent -->
