# Proposal: Admin Migration to Next.js

## Intent
Migrate the existing Go Template-based admin panel to a modern Next.js application to handle growing complexity, specifically User Management, Role-Based Access Control (RBAC), and dynamic Sector Assignment for reading roles. This improves maintainability and provides a premium UI/UX consistent with the Infira brand.

## Scope

### In Scope
- Setup of Next.js application with TailwindCSS and Connect-ES.
- Implementation of `AdminService` in Go (ConnectRPC).
- Database schema for Users, Roles, and Sector Permissions.
- Authentication system (JWT/Session) for Admin.
- Migration of existing dashboard features: Customers, Readings, Settings, Reports.
- New features: User/Role management and Sector Assignment.

### Out of Scope
- Mobile app redesign (staying with Flutter).
- Public-facing customer portal (only internal admin).
- Third-party SSO integration (local auth for now).

## Capabilities

### New Capabilities
- `admin-auth`: Handle login, session management, and JWT issuance for administrative tasks.
- `user-roles`: Manage system users, their roles (Admin, Reader, Supervisor), and specific sector permissions.

### Modified Capabilities
- `reading-registration`: Add server-side validation to ensure a user only submits readings for assigned sectors.
- `report-generation`: Filter reports based on user permissions/assigned sectors.

## Approach
Incremental migration using a "BFF" (Backend For Frontend) pattern where Next.js communicates with Go via ConnectRPC. We will use `Shadcn/UI` for a premium look and `Zustand` or `TanStack Query` for state management. The Go backend will remain the source of truth for all data and validation.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `backend/cmd/admin/` | Removed | Legacy handlers and templates to be phased out. |
| `backend/cmd/server/main.go` | Modified | Registration of new Admin RPC services. |
| `proto/involt/v1/admin.proto` | New | API definitions for Admin services. |
| `admin-ui/` | New | Next.js frontend application. |
| `db/migrations/` | New | Schema updates for users, roles, and permissions. |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Auth Complexity | Medium | Use a well-tested library like `next-auth` or standard Connect interceptors. |
| Breaking Sincronization | Low | Ensure RPC services maintain compatibility with existing repositories. |
| Learning Curve | Low | Use standard React/Next.js patterns. |

## Rollback Plan
Maintain the `backend/cmd/admin` code until the new UI is 100% verified. We can toggle between them using environment variables or a reverse proxy path configuration.

## Dependencies
- Node.js 20+
- Connect-ES and Buf for TS client generation.

## Success Criteria
- [ ] Next.js app is deployed and accessible.
- [ ] Users can login with specific roles.
- [ ] Readers can only view/edit customers in their assigned sectors.
- [ ] All existing admin features (PDF, Settings, Stats) are functional in the new UI.
