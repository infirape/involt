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
- Use Bubbletea TUI testing patterns for CLI tools.
- Mock external dependencies (DB, API) where possible.

## Project Conventions

| File | Path | Notes |
|------|------|-------|
| README.md | /Users/hbs/.gemini/antigravity/scratch/infira-mvp/README.md | Project root |

Read the convention files listed above for project-specific patterns and rules.
