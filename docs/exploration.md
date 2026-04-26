## Exploration: InVolt Native App Architecture

### Current State
- Project: InVolt (Infira MVP).
- Goal: Digitalize meter reading in Chetilla, Cajamarca.
- Requirement: Native App with robust offline database.

### Affected Areas
- `mobile/`: Flutter application.
- `backend/`: Go sync engine.

### Approach: Native Flutter + Go Sync Engine
1. **Frontend (Mobile)**:
   - **Framework**: Flutter.
   - **Local DB**: SQLite (Drift) for structured data and complex queries.
   - **Sync Protocol**: Optimistic UI with background synchronization.
   - **Location**: GPS tracking for reading validation.
   - **Photos**: Local storage with queued upload to S3/Cloud Storage.

2. **Backend (Sync Engine)**:
   - **Language**: Go.
   - **API**: ConnectRPC (Protobuf).
   - **Data Store**: PostgreSQL (Remote) + Redis (Cache).
   - **Auth**: JWT based.

### Recommendation
Proceed with a Clean Architecture on Flutter and a Hexagonal Architecture on Go. Use Drift for the local database to ensure type-safety and easy migrations.

### Risks
- **Connectivity**: Syncing high-resolution photos in 3G zones. Solution: Automatic resizing before upload.
- **Battery**: GPS usage must be optimized.
- **Data Integrity**: Conflict resolution between offline edits.

### Ready for Proposal
Yes.
