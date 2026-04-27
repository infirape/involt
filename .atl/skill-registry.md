# Skill Registry

**Delegator use only.** Any agent that launches sub-agents reads this registry to resolve compact rules, then injects them directly into sub-agent prompts. Sub-agents do NOT read this registry or individual SKILL.md files.

## User Skills

| Trigger | Skill | Path |
|---------|-------|------|
| When building web components, pages, artifacts, posters, or applications | frontend-design | /Users/hbs/.gemini/antigravity/skills/frontend-design/SKILL.md |
| When creating a pull request, opening a PR, or preparing changes for review | branch-pr | /Users/hbs/.gemini/antigravity/skills/branch-pr/SKILL.md |
| When writing Go tests, using teatest, or adding test coverage | go-testing | /Users/hbs/.gemini/antigravity/skills/go-testing/SKILL.md |
| When syncing tasks with Jira or connecting to a Jira board | jira-integration | /Users/hbs/.gemini/antigravity/skills/jira-integration/SKILL.md |

## Compact Rules

### frontend-design
- Use vibrant colors, dark modes, glassmorphism, and dynamic animations.
- Prioritize visual excellence: curated HSL palettes, modern typography (Google Fonts).
- Use smooth gradients and interactive elements (hover effects).
- No placeholders: use generate_image for real assets.
- Follow "Design Aesthetics" from web_application_development instructions.

### branch-pr
- Use conventional commits only.
- Never add AI attribution or "Co-Authored-By".
- Ensure PR description summarizes changes clearly.

### go-testing
- Use standard Go testing for backend logic.
- Mock external dependencies where possible.
- Use `httptest` for RPC/HTTP handlers.

### jira-integration
- Connect to Jira API using credentials from .env.
- Sync tasks with Jira board status.

## Project Conventions

| File | Path | Notes |
|------|------|-------|
| AGENTS.md | /Users/hbs/Documents/infira/involt/AGENTS.md | Core project rules and rules |
| README.md | /Users/hbs/Documents/infira/involt/README.md | Project root |

Read the convention files listed above for project-specific patterns and rules.
