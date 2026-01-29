# Plan: User Authentication System

## Problem
The application currently has no user authentication. Users cannot create accounts, log in, or have personalized experiences. We need a secure, scalable authentication system that supports email/password login with future extensibility for OAuth providers.

## Solution
Implement JWT-based authentication with refresh tokens. Use bcrypt for password hashing and PostgreSQL for user storage. Create a clean separation between auth logic and route handlers to allow easy addition of OAuth later.

Key decisions:
- JWT access tokens (15min expiry) + refresh tokens (7 day expiry)
- Separate auth service module for testability
- Rate limiting on login endpoints

## Tasks
<!-- Tasks are numbered in execution order. Each task depends on all previous tasks being complete. -->
- [ ] [01-setup-database](tasks/01-setup-database.md) - Configure PostgreSQL and create user schema
- [ ] [02-create-user-model](tasks/02-create-user-model.md) - User model with password hashing
- [ ] [03-implement-jwt-service](tasks/03-implement-jwt-service.md) - Token generation and validation
- [ ] [04-create-auth-routes](tasks/04-create-auth-routes.md) - Register, login, refresh endpoints
- [ ] [05-add-middleware](tasks/05-add-middleware.md) - Auth middleware for protected routes
- [ ] [06-write-tests](tasks/06-write-tests.md) - Unit and integration tests

## Dependencies
- PostgreSQL 14+ running locally or connection string for remote
- Node.js 18+

## Notes
- Decided against session-based auth for better scalability
- Will add OAuth in a future iteration (not in scope for this plan)
- Rate limiting deferred to task 04 to keep tasks focused
