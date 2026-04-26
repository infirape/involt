# Proposal: InVolt Foundation (Data & API)

## Intent
Establish the core data structures and communication contracts for InVolt. Since the app must work offline in Chetilla, we need a robust local database and a reliable synchronization mechanism with the Go backend.

## Scope
### In Scope
- Define Protobuf messages for Customers, Meters, and Readings.
- Design the SQLite (Drift) schema for local persistence.
- Define the `SyncService` contract for bidirectional data exchange.
- Implementation of the basic domain models in both Flutter and Go.

### Out of Scope
- UI/UX implementation of the screens (deferred to next phase).
- Background sync worker implementation (deferred).
- Authentication flow details (deferred).

## Capabilities
### New Capabilities
- **customer-management**: Local storage and retrieval of customer/meter info.
- **reading-registration**: Capture and store meter readings with photo metadata.
- **sync-engine**: Contract for syncing local data with the cloud.

### Modified Capabilities
- None.

## Approach
Use a **Protobuf-first** approach. Define all entities in `.proto` files to generate type-safe code for both Go and Flutter. On the mobile side, use **Drift** (SQLite) for the local DB, mapping Protobuf entities to DB tables.

## Affected Areas
| Area | Impact | Description |
|------|--------|-------------|
| `backend/proto/` | New | Protobuf definitions |
| `mobile/lib/core/data/` | New | Local DB and Repository interfaces |
| `backend/internal/domain/` | New | Go domain models |

## Risks
| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Protobuf version mismatch | Low | Use a unified proto repository or shared folder. |
| Schema migration complexity | Med | Use Drift's migration manager from day one. |

## Rollback Plan
Since this is the foundation, rollback means deleting the generated code and reverting the proto changes. No production data yet.

## Success Criteria
- [ ] Protobuf files compile for both Go and Dart.
- [ ] SQLite database can be initialized on a mobile device.
- [ ] Integration tests verify that a reading can be saved locally and read back.
