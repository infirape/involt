# Reading Registration Specification

## Purpose
Register electric meter readings with evidence and metadata.

## Requirements

### Requirement: Manual kWh Entry
The system MUST allow the user to input the current kWh reading from the meter.

#### Scenario: Register valid reading
- GIVEN an active customer selection
- WHEN I enter "1250.5" in the kWh field
- THEN the system SHALL save the reading.

### Requirement: Photo Evidence
The system MUST require a photo as evidence for each reading.

#### Scenario: Missing photo validation
- GIVEN a reading entry with kWh filled
- WHEN I try to save without taking a photo
- THEN the system SHALL show an error message and prevent saving.

### Requirement: Automatic Metadata
The system MUST automatically record the timestamp (Peru UTC-5) and GPS location.

#### Scenario: Auto-timestamp and GPS
- GIVEN a successful reading save
- WHEN I view the reading details
- THEN I SHALL see the exact time in Peru and the GPS coordinates.
