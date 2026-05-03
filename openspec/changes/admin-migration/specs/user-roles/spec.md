# User Roles Specification

## Purpose
Manage system users and their hierarchical permissions (RBAC) and sector assignments.

## Requirements

### Requirement: Role Definition
The system MUST support at least three roles: ADMIN, SUPERVISOR, and READER.

#### Scenario: Admin full access
- GIVEN a user with the ADMIN role
- WHEN they access any module in the Admin UI
- THEN the system SHALL allow full read/write access.

### Requirement: Sector Assignment
The system MUST allow assigning one or more sectors to a specific user.

#### Scenario: Assign sectors to reader
- GIVEN a user with the READER role
- WHEN I select Sectors "A" and "B" and save their profile
- THEN the user SHALL only be permitted to see and register readings for those sectors.

### Requirement: Permission Enforcement
The backend MUST validate that every write operation (Readings, Customer Updates) is performed by a user with permission for that sector.

#### Scenario: Unauthorized sector registration
- GIVEN a user with permission only for Sector "A"
- WHEN they attempt to push a reading for Sector "B"
- THEN the system SHALL reject the request with a PermissionDenied error.
