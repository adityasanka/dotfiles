# Task: Create User Model

## Status
<!-- TODO | IN PROGRESS | DONE | SKIPPED -->
DONE

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
- [x] Install bcrypt package
- [x] Create models/user.js with User class
- [x] Implement User.create() with password hashing
- [x] Implement User.findByEmail()
- [x] Implement User.verifyPassword()
- [x] Add input validation (email format, password length)

## Files to Modify
- `package.json` - Add bcrypt dependency
- `models/user.js` - New file, User model
- `models/index.js` - New file, export models

## Verification
- [x] Tests pass: `npm test -- --grep "User model"` (timeout: 5min)
- [x] Builds without errors: `npm run build` (timeout: 2min)
- [x] Works as expected: Create user via REPL, verify password hash differs from input

## Notes
<!-- Implementation notes added during execution -->
- Used bcrypt cost factor 12 as proposed; 10 was too fast for security, 14 too slow for UX
- Added async/await wrapper around bcrypt.hash() for cleaner code
- Email validation uses simple regex; considered validator.js but kept deps minimal
- Password minimum length set to 8 chars per OWASP guidelines
- findByEmail returns null instead of throwing for non-existent users (easier login flow)
- Added unique constraint error handling in create() - returns friendly message
