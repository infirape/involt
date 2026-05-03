# Delta for Report Generation

## MODIFIED Requirements

### Requirement: Batch PDF Generation
The Go backend MUST generate a PDF for each reading in a selected period, filtered by the sectors assigned to the requesting user.
(Previously: The Go backend MUST generate a PDF for each reading in a selected period.)

#### Scenario: Generate monthly report (Admin)
- GIVEN a user with ADMIN role
- AND a set of 100 readings for April 2026 across all sectors
- WHEN I trigger the report generation
- THEN the system SHALL produce 100 PDF files for all sectors.

#### Scenario: Generate monthly report (Supervisor/Reader)
- GIVEN a user with permission ONLY for Sector "A"
- AND a set of 100 readings for April 2026 (50 in Sector A, 50 in Sector B)
- WHEN I trigger the report generation
- THEN the system SHALL produce ONLY 50 PDF files corresponding to Sector A.
