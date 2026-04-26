# Report Generation Specification

## Purpose
Generate mass PDF reports for meter readings.

## Requirements

### Requirement: Batch PDF Generation
The Go backend MUST generate a PDF for each reading in a selected period.

#### Scenario: Generate monthly report
- GIVEN a set of 100 readings for April 2026
- WHEN I trigger the report generation
- THEN the system SHALL produce 100 PDF files ready for download or distribution.
