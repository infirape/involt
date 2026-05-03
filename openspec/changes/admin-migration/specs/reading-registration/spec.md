# Delta for Reading Registration

## ADDED Requirements

### Requirement: Server-side Sector Validation
The system MUST validate that the authenticated user has permission to register readings for the customer's sector.

#### Scenario: Register reading in authorized sector
- GIVEN a user with permission for Sector "Centro"
- AND a customer belonging to Sector "Centro"
- WHEN the user submits a new reading
- THEN the system SHALL accept and save the reading.

#### Scenario: Register reading in unauthorized sector
- GIVEN a user with permission for Sector "Centro"
- AND a customer belonging to Sector "Norte"
- WHEN the user submits a new reading
- THEN the system SHALL reject the request with a PermissionDenied error.
