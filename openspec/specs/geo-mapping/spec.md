# Geo Mapping Specification

## Purpose
Visualize customers on a map for better field navigation and task management.

## Requirements

### Requirement: Sector-based Map Visualization
The system MUST display customers as pins on a map, color-coded or filtered by Sector.

#### Scenario: View customers in Sector A
- GIVEN the map view
- WHEN I select "Sector A" filter
- THEN I SHALL see pins only for customers in "Sector A".

### Requirement: Map Interaction
Clicking on a customer pin MUST open the Reading Registration Modal for that customer.

#### Scenario: Open registration from map
- GIVEN a customer pin on the map
- WHEN I click the pin
- THEN the system SHALL open the Reading Registration Modal with the customer already selected.
