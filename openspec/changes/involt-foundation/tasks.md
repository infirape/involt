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

## Phase 5: Field Operations UI (Search & Sync)

- [x] 5.1 Implement Premium Search with map centering and floating results list. [INVOL-21]
- [x] 5.2 Integrate QR/Barcode Scanner (mobile_scanner) with neon overlay and automatic search. [INVOL-22]
- [x] 5.3 Implement bidirectional synchronization loop (Push Readings / Pull Metadata) via ConnectRPC. [INVOL-23]
- [x] 5.4 Unify navigation: Auto-switch from sectors list to map with proactive centering. [INVOL-24]
- [x] 5.5 Enhance Reading registration UX with custom numeric keypad and auto-scrolling input. [INVOL-25]

## Phase 6: Full Integration (End-to-End)

- [x] 6.1 Implement PostgreSQL persistence in Backend (Hexagonal Adapters). [INVOL-26]
- [x] 6.2 Implement `PullMetadata` in Backend to serve real database entities. [INVOL-27]
- [x] 6.3 Implement `PullMetadata` logic in Mobile `SyncService` to update Drift DB. [INVOL-28]
- [x] 6.4 Implement Photo Evidence upload and storage (S3/Local) in Backend. [INVOL-29]
- [x] 6.5 Implement Go-based PDF Generation Engine for reading receipts. [INVOL-30]
- [x] 6.6 Final end-to-end sync verification: From mobile scan to backend PDF. [INVOL-31]
