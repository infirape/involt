## Exploration: Admin Migration

### Current State
The current admin system is built with Go Templates and HTMX inside `backend/cmd/admin`. It handles customer listings, settings, and receipt generation but lacks any authentication or user management. The logic is heavily coupled with template rendering.

### Affected Areas
- `backend/cmd/admin/handler.go` — Legacy handler to be phased out.
- `backend/cmd/server/main.go` — Registration of new RPC services.
- `proto/involt/v1/` — New `admin.proto` for RPC definitions.
- `backend/internal/adapters/handlers/` — New RPC handlers.
- New `admin-ui/` directory — Next.js application.

### Approaches
1. **Next.js + Connect-ES** — Full rewrite of the frontend using a modern framework and RPC communication.
   - Pros: High quality UI, strict typing, scalable architecture.
   - Cons: Higher initial setup effort.
   - Effort: High

2. **Refactored HTMX** — Keeping Go templates but cleaning up the handler and adding Auth middlewares.
   - Pros: Simpler deployment, no new tech stack.
   - Cons: Harder to build complex interactive dashboards.
   - Effort: Medium

### Recommendation
Option 1: **Next.js + Connect-ES**. It aligns with the requirement for "visual excellence" and provides the best foundation for complex features like RBAC and sector assignment.

### Risks
- Auth implementation (unified JWT/Cookie strategy).
- CORS configuration between Next.js and Go.
- Parallel maintenance of legacy and new admin during transition.

### Ready for Proposal
Yes. The next phase will define the specific technology stack for the UI, the database schema for roles/users, and the RPC service definitions.
