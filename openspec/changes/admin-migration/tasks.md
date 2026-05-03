# Tasks: Admin Migration to Next.js

## Phase 1: Foundation & Infrastructure
- [x] 1.1 Initialize Next.js app in `admin-ui/` with TailwindCSS and Connect-ES.
- [x] 1.2 Create `proto/involt/v1/admin.proto` with User, Role, and Permission definitions.
- [x] 1.3 Implement DB migrations for `users`, `roles`, and `user_sectors` tables in PostgreSQL.
- [x] 1.4 Setup ConnectRPC server in Go for the new `AdminService`.

## Phase 2: Authentication & Security
- [x] 2.1 Implement JWT-based authentication in Go backend.
- [x] 2.2 Create Login page in Next.js with visual parity to current brand.
- [x] 2.3 Implement RBAC middleware in Next.js to protect admin routes.
- [ ] 2.4 Implement sector-level validation in Go repositories/handlers.

## Phase 3: User & Role Management
- [ ] 3.1 Implement RPC handlers for User CRUD.
- [ ] 3.2 Create User Management UI in Next.js.
- [ ] 3.3 Implement RPC handlers for Role and Sector Assignment.
- [ ] 3.4 Create Role/Sector Assignment UI in Next.js.

## Phase 4: Feature Parity Migration
- [ ] 4.1 Migrate Dashboard & Stats cards with pixel-perfect parity to current design.
- [ ] 4.2 Migrate Customer Listing & Filtering with exact same columns and interactions.
- [ ] 4.3 Migrate Customer Detail and History modals.
- [ ] 4.4 Migrate Settings panel and Receipt generation UI.

## Phase 5: Testing & Verification
- [ ] 5.1 Write unit tests for new `AdminService` handlers in Go.
- [ ] 5.2 Write integration tests for RBAC and Sector permissions.
- [ ] 5.3 Conduct visual parity audit between legacy and new Admin UI.
- [ ] 5.4 Verify all PDF receipts generate correctly from the new UI.
