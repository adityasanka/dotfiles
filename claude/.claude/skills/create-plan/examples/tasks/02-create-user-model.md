# Task: Create User Model

## Status
<!-- TODO | IN PROGRESS | DONE -->
TODO

## Requires
- Task 01 must be complete

## Description
Create the User model with secure password hashing using bcrypt. Implement methods for creating users, validating passwords, and finding users by email. This provides the core user entity for authentication.

## Proposed Solution
Create a `models/user.js` module that encapsulates all user-related database operations. Use bcrypt with cost factor 12 for password hashing. Never store or return plain passwords.

```javascript
// Key methods to implement
User.create({ email, password })     // Hash password, insert, return user (no hash)
User.findByEmail(email)              // Find user for login
User.verifyPassword(user, password)  // Compare password with hash
```

## Subtasks
- [ ] Install bcrypt package
- [ ] Create models/user.js with User class
- [ ] Implement User.create() with password hashing
- [ ] Implement User.findByEmail()
- [ ] Implement User.verifyPassword()
- [ ] Add input validation (email format, password length)

## Files to Modify
- `package.json` - Add bcrypt dependency
- `models/user.js` - New file, User model
- `models/index.js` - New file, export models

## Verification
- [ ] Tests pass: `npm test -- --grep "User model"`
- [ ] Builds without errors: `npm run build`
- [ ] Works as expected: Create user via REPL, verify password hash differs from input

## Notes
<!-- Context for execution agent -->
