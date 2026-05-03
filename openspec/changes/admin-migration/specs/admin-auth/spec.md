# Admin Auth Specification

## Purpose
Secure access to the Admin Panel through authentication and session management.

## Requirements

### Requirement: JWT-based Authentication
The system MUST authenticate administrative users using JWT tokens issued after a valid login.

#### Scenario: Successful login
- GIVEN a valid administrative user in the database
- WHEN I submit the correct email and password to the login endpoint
- THEN the system SHALL return a JWT token and a success message.

#### Scenario: Invalid login
- GIVEN an existing user
- WHEN I submit an incorrect password
- THEN the system SHALL return a 401 Unauthorized error.

### Requirement: Session Management
The Admin UI MUST store the JWT securely and include it in all subsequent RPC calls to the backend.

#### Scenario: Unauthorized access
- GIVEN a protected admin route (e.g., /admin/users)
- WHEN I attempt to access it without a valid JWT
- THEN the system SHALL redirect me to the login page.
