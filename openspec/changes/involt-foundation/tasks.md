# Tasks: InVolt Foundation (Data & API)

## Phase 1: Foundation (Contracts & Proto)

- [x] 1.1 Add required dependencies (Drift, Protobuf, ConnectRPC) to `mobile/pubspec.yaml` and `backend/go.mod`. [INVOL-1]
- [x] 1.2 Create `proto/involt/v1/models.proto` with core entities: `Customer`, `Meter`, `Reading`. [INVOL-2]
- [x] 1.3 Create `proto/involt/v1/sync.proto` defining `SyncService` (PushReadings, PullMetadata). [INVOL-3]
- [x] 1.4 Configure proto generation for Go (`backend/internal/gen/proto`) and Dart (`mobile/lib/core/gen/proto`). [INVOL-4]
- [x] 1.5 Generate code and verify compilation on both platforms. [INVOL-5]

## Phase 2: Backend Core (Domain & Ports)

- [x] 2.1 Create `backend/internal/domain/models.go` with domain-specific entities. [INVOL-6]
- [x] 2.2 Implement mapping logic between Protobuf models and Domain entities in `backend/internal/domain/mappers.go`. [INVOL-7]
- [x] 2.3 Define repository interfaces in `backend/internal/ports/repositories.go`. [INVOL-8]

## Phase 3: Mobile Core (Persistence & Domain)

- [x] 3.1 Initialize Drift database in `mobile/lib/core/data/database.dart`. [INVOL-9]
- [x] 3.2 Define Drift tables for `Customers`, `Meters`, and `Readings` matching the proto schema. [INVOL-10]
- [x] 3.3 Create `mobile/lib/core/domain/repositories/reading_repository.dart` interface. [INVOL-11]
- [x] 3.4 Implement `mobile/lib/core/data/repositories/drift_reading_repository.dart` for local persistence. [INVOL-12]

## Phase 4: Verification & Testing

- [x] 4.1 Write Go tests for domain mappers in `backend/internal/domain/mappers_test.go`. [INVOL-13]
- [x] 4.2 Write Drift integration tests in `mobile/test/core/data/database_test.dart`. [INVOL-14]
- [x] 4.3 Verify end-to-end type safety between proto, backend domain, and mobile DB. [INVOL-15]
