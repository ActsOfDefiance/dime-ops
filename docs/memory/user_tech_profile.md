---
name: User tech profile
description: Vance's technology preferences, strengths, and constraints for this project
type: user
---

**Strong in:** PostgreSQL, Redis, Python, TypeScript (not React — never React), Google Cloud, Rust, ZeroMQ, RabbitMQ, Git/Gitflow.

**Git discipline:** Gitflow always. Never work directly in `main` or `develop`. All work on feature/*, hotfix/*, or release/* branches. This is a hard rule across all repos.

**Frontend preference:** Svelte/SvelteKit. Has an existing Svelte project with a two-pane chat UI being abstracted for reuse with dime.

**No React under any circumstances.** This is a hard constraint.

**Workflow style:** Prefers native local dev (existing local Postgres/Redis/Hugo — no Docker overhead day-to-day). Docker Compose is acceptable as opt-in for onboarding/CI.

**Cost sensitivity:** Early stage, pre-funding. ~$25-30/month GCP acceptable. Prefers single billing stack (GCP) over spreading across providers unless cost is prohibitive.

**ADK:** Wants to keep Google ADK (Agent Development Kit) as the agent framework. Was blocked ~1 year ago waiting for ADK and Google Deep Research API to mature.

**Design sensibility:** Appreciates high-fidelity wireframes (called the brainstorming wireframes "excellent"). Interested in using Stitch MCP for design systems. Thinking about Astro for a more feature-rich future site UI.

**Collaboration style:** Thinks at architectural level, asks deferral questions thoughtfully, comfortable reasoning about trade-offs. Prefers decisions to be noted as tickets when not ready to resolve.

**Tooling choices:** Pyright (not mypy), Bun (not Node/npm/npx), ruff, pytest. Svelte testing: Vitest + Storybook + Playwright. Pre-commit hooks AND Claude hooks — do things right before git forces it.
