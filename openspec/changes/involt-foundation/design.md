# Design: InVolt Foundation (Data & API)

## Technical Approach

Establish a **Protobuf-first** contract that acts as the single source of truth for both the Go backend and the Flutter mobile app. This ensures that the synchronization logic is based on identical data structures. The mobile side will use **Drift** for a robust offline-first experience, while the backend follows a **Hexagonal Architecture** for clear separation of concerns.

## Architecture Decisions

### Decision: Protobuf as Single Source of Truth
**Choice**: Use `.proto` files to define all shared entities (Customer, Reading, Meter).
**Alternatives considered**: JSON-based REST, Dart-only classes.
**Rationale**: In an offline-first sync environment, type safety and schema consistency are non-negotiable. Protobuf handles serialization efficiently and generates typed code for both Go and Dart.

### Decision: Drift (SQLite) for Mobile Persistence
**Choice**: Drift (formerly moor).
**Alternatives considered**: Isar, Hive, Sqflite (raw).
**Rationale**: Drift provides strongly-typed SQL queries, excellent migration management, and reactive streams. Given the relational nature of Customers -> Meters -> Readings, a relational DB is the most natural fit.

### Decision: Hexagonal Architecture for Backend
**Choice**: Clear separation between Domain, Ports, and Adapters.
**Alternatives considered**: Layered Architecture (MVC).
**Rationale**: Allows us to swap the database implementation or the API transport (e.g., from ConnectRPC to something else) without touching the core business logic.

## Data Flow

    [Mobile UI] ──→ [Drift DB] ──→ [Sync Service] ──→ [ConnectRPC API] ──→ [PostgreSQL]
         ↑              │               │                                     │
         └──────────────┴───────────────┴─────────────────────────────────────┘

1. User captures reading (offline).
2. Data is saved immediately to **Drift DB**.
3. **Sync Service** (background) detects pending changes.
4. Data is pushed to **ConnectRPC API** when connectivity is available.
5. Backend persists to **PostgreSQL**.

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `proto/involt/v1/models.proto` | Create | Core entities (Customer, Meter, Reading) |
| `proto/involt/v1/sync.proto` | Create | Sync service contract |
| `backend/internal/domain/models.go` | Create | Domain entities mapped from proto |
| `mobile/lib/core/data/database.dart` | Create | Drift database and table definitions |
| `mobile/lib/core/domain/repositories/sync_repository.dart` | Create | Interface for data synchronization |

## Interfaces / Contracts

### Proto Example (models.proto)
```proto
message Customer {
  string id = 1;
  string name = 2;
  string community = 3;
  string sector = 4;
}

message Reading {
  string id = 1;
  string customer_id = 2;
  double kwh = 3;
  string photo_url = 4;
  int64 timestamp = 5;
  double latitude = 6;
  double longitude = 7;
}
```

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| Unit (Go) | Domain logic and mapping | Standard `testing` package |
| Unit (Dart) | Drift table operations | `drift_dev` testing utilities |
| Integration | Protobuf compilation and sync contract | Scripted validation of generated code |

## Migration / Rollout

No migration required for the initial foundation. Drift migration manager will be initialized with version 1.

## Open Questions

- [ ] ¿Cómo manejamos la carga inicial de datos de los 14 sectores de Chetilla? (Se resolverá en la fase de implementación de carga masiva).
- [ ] ¿Es necesario soporte para múltiples fotos por lectura o con una es suficiente? (Por ahora, una sola).
