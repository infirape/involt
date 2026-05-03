# InVolt - Project Conventions & Rules

Este documento centraliza las reglas de arquitectura y desarrollo para InVolt. Todos los agentes deben seguir estas pautas.

## Stack Tecnológico
- **Mobile**: Flutter (SDK estable)
- **Backend**: Go 1.23+ (ConnectRPC)
- **Admin UI**: Next.js 15+ (App Router), ConnectRPC, Tailwind CSS 4+, Biome, Shadcn/UI
- **Database**: 
  - Local: SQLite (Drift) / Isar
  - Remote: PostgreSQL
- **Estética**: Infira Premium (Magenta: #FF00FF, Cyan: #00FFFF, Dark Mode)

## Arquitectura
- **Mobile**: Clean Architecture (Data, Domain, Presentation)
- **Backend**: Hexagonal Architecture
- **Admin UI**: Modular Clean Architecture (Components, Hooks, Services, Lib)
- **Sync**: Offline-First. Todas las lecturas se guardan localmente y se sincronizan en segundo plano.

## Reglas de Código
- **Tests**: Strict TDD Mode activo. No se escribe lógica sin su correspondiente test.
- **Lints**: 
  - Mobile: `analysis_options.yaml`
  - Backend: `golangci-lint`
  - Admin UI: **Biome (Strict)**. Prohibido el uso de `any`. `tsconfig.json` con modo estricto.
  - **Modularidad**: Ningún archivo debe superar las **300 líneas**. Si un archivo crece más, se debe modularizar (separar componentes, extraer lógica a hooks, etc.).
- **Commits**: Usar Conventional Commits (feat, fix, refactor, docs).

## Consideraciones para la IA (MANDATORIO)
- **Sincronización de Mocks**: Si modificás una interfaz en `backend/internal/ports`, **DEBÉS** actualizar inmediatamente los mocks en los tests de `backend/cmd/` para evitar errores de compilación.
- **Sincronización de Base de Datos**: Si modificás el esquema en `mobile/lib/core/data/database.dart`, **DEBÉS** actualizar los constructores en `mobile/test/core/data/database_test.dart`.
- **Estabilidad de Tests UI**: Evitar tests de widgets que dependan de timers largos (como el de la SplashScreen) o llamadas a red reales. Usar mocks para `SyncService`.


## Skills Activas

| Skill | Descripción | Trigger |
|-------|-------------|---------|
| `jira-integration` | Gestión de tareas en Jira | Sincronizar tasks con Jira board |

## Credenciales y Acceso
- **Jira**: Acceso vía API habilitado. Las credenciales (`JIRA_API_TOKEN`, `JIRA_USER_EMAIL`) se encuentran en el archivo `.env` del root. **USAR SIEMPRE LA API** (curl/rest) en lugar del navegador para actualizaciones de tareas.

## Archivos de Referencia
- [README.md](./README.md) - Visión general del proyecto
- [.atl/skill-registry.md](./.atl/skill-registry.md) - Catálogo de skills de IA
