# Open Decisions

Deferred architectural and tooling decisions. Each entry has enough context to make the call when the time comes. Once resolved, move to `settled-decisions.md`.

---

## DECISION-002: UI framework & design system

**Decision needed before:** UI implementation sprint

**Direction:** shadcn-svelte is the leading candidate (accessibility, ARIA, keyboard nav, consistent patterns). Stitch MCP is available in this environment to generate the style guide and design tokens.

**Action:** Run Stitch before committing to any component library. Confirm Tailwind dependency is acceptable. Verify no conflicts with the existing Svelte project being abstracted for reuse.

**Reference:** `docs/wireframes/dime-ui-chat-panes.html`

---

## DECISION-003: Static site generator — Hugo vs. Astro

**Decision needed before:** significant theme/layout work on acts_of_defiance site

**Current:** Hugo (in place, fast, zero Node.js dependency, single binary).

**Consider:** Astro — native Svelte component support, Content Collections built for markdown + typed frontmatter, TypeScript-first, excellent built-in image optimization. Shared design system components between site and dime UI is the compelling reason.

**Low-risk swap:** `PublishingAdapter` interface means an `AstroAdapter` is just a new file. Don't invest in Hugo templates until this is decided.

---

## DECISION-004: Infrastructure provider — GCP vs. managed alternatives

**Decision needed before:** first production deploy

**GCP estimate:** Cloud SQL (~$10/mo) + Memorystore (~$16/mo) ≈ $25–30/month. Single billing stack, no extra agreements.

**Alternatives if cost is a concern:**
- PostgreSQL: Neon (serverless, scales to zero, generous free tier)
- Redis: Upstash (serverless, pay-per-request, free tier)
- Both use standard wire protocols — zero code changes, connection string swap only.

---

## DECISION-005: Workflow config UI

**Decision needed before:** multi-user team workflow is needed

**Scope:** settings screen for managing workflow presets, role assignments per project, notification adapter configuration.

Not critical path. `solo` preset covers the immediate use case.

---

## DECISION-006: Slack + SMS notification adapters

**Decision needed before:** multi-user team workflow is needed

**Scope:** `SlackNotificationAdapter` and `SMSNotificationAdapter` (Twilio). Interface (`NotificationAdapter` Protocol) is already defined. Implementation is straightforward once the solo workflow is validated.

---

## DECISION-007: Observability tooling — Logfire vs. alternatives

**Decision needed before:** production deployment / any serious debugging work

**Current state:** Logfire is already configured in the `dime` codebase with FastAPI and SQLAlchemy integration.

**Question:** Is Logfire still the right choice given the new architecture?

**Alternatives:**
- **OpenTelemetry + GCP Cloud Trace** — vendor-neutral, native GCP integration, no extra service
- **Sentry** — error tracking + performance, generous free tier, excellent Python/FastAPI SDK
- **Keep Logfire** — already integrated, good structured logging, works with ADK

**Consideration:** the new architecture has multiple services (API, workers, broker). Distributed tracing matters more now than in the Phase 0 single-process setup. GCP Cloud Trace + Cloud Logging is free and already in the stack.

---

## DECISION-010: GitHub Projects for cross-repo issue aggregation

**Decision needed before:** team workflow is in active use

**Scope:** Org-level GitHub Project board for aggregating issues across dime, dime-ui, acts-of-defiance, and dime-ops. Not needed until a second contributor joins.
