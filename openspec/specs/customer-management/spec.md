# Customer Management Specification

## Purpose
Manage customers, communities, and sectors for meter reading assignments.

## Requirements

### Requirement: Community and Sector Filtering
The system MUST allow users to filter customers by Community and then by Sector.

#### Scenario: Filter customers by sector
- GIVEN a list of customers in "Chetilla" community
- WHEN I select "Sector A"
- THEN I SHALL see only customers belonging to "Sector A" in "Chetilla".

### Requirement: Searchable Customer Dropdown
The system MUST provide a searchable dropdown to select a specific customer within a filtered list.

#### Scenario: Search customer by name
- GIVEN the customer list for "Sector A"
- WHEN I type "Juan" in the search dropdown
- THEN the list SHALL show only customers containing "Juan".
