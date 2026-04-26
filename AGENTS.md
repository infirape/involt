# InVolt - Project Conventions & Rules

Este documento centraliza las reglas de arquitectura y desarrollo para InVolt. Todos los agentes deben seguir estas pautas.

## Stack Tecnológico
- **Mobile**: Flutter (SDK estable)
- **Backend**: Go 1.23+ (ConnectRPC)
- **Database**: 
  - Local: SQLite (Drift) / Isar
  - Remote: PostgreSQL
- **Estética**: Infira Premium (Magenta: #FF00FF, Cyan: #00FFFF, Dark Mode)

## Arquitectura
- **Mobile**: Clean Architecture (Data, Domain, Presentation)
- **Backend**: Hexagonal Architecture
- **Sync**: Offline-First. Todas las lecturas se guardan localmente y se sincronizan en segundo plano.

## Reglas de Código
- **Tests**: Strict TDD Mode activo. No se escribe lógica sin su correspondiente test.
- **Lints**: Seguir las recomendaciones de `analysis_options.yaml` en mobile y `golangci-lint` en backend.
- **Commits**: Usar Conventional Commits (feat, fix, refactor, docs).

## Skills Activas

| Skill | Descripción | Trigger |
|-------|-------------|---------|
| `jira-integration` | Gestión de tareas en Jira | Sincronizar tasks con Jira board |

## Archivos de Referencia
- [README.md](./README.md) - Visión general del proyecto
- [.atl/skill-registry.md](./.atl/skill-registry.md) - Catálogo de skills de IA
