---
name: Issues and implementation workflow
description: How we manage planning, epics, tickets, and implementation — local markdown, epic-driven, incremental
type: feedback
---

Keep planning local in `docs/issues/` markdown. Sync to GitHub Issues when ready to actively work a ticket.

**Why:** Local markdown is faster to iterate on during planning, doesn't require GitHub auth or connectivity, and keeps design conversations out of the ticket tracker. GitHub Issues are for active work tracking, not spec exploration.

**How to apply:** New tickets go in `docs/issues/` first. Use GitHub Issues when a ticket moves to active development. Do not create GitHub Issues speculatively for work that is weeks out.

---

## Epic structure

Epics live in `docs/issues/epic-*.md`. Each epic:
- Has a clear goal (one sentence)
- Lists sub-issues with markdown links to individual ticket files
- Shows the dependency order explicitly
- Has a Definition of Done checklist

Sub-issues for significant work items get their own ticket files. Micro-tasks can stay as checklist items inside the epic.

**Why:** User wants incremental, ticket-driven development. Each epic can be focused on independently. Epics make dependency chains visible so we know what to do next.

---

## Implementation planning

Do NOT write a monolithic implementation plan. Instead:
1. Work through epics in order (ops-setup → dime-core → dime-ui → acts-of-defiance → production)
2. When starting an epic, review its sub-issues and write a per-issue implementation plan at that time
3. Each implementation plan is scoped to one ticket — not the whole epic

**Why:** Detailed plans for work 6 weeks out are wasted effort. Plans written just-in-time reflect current understanding of the codebase.

---

## Finding gaps

When creating epics and sub-issues, note any gaps in the architecture/design docs. Raise those as issues or open decisions at the time of discovery — do not silently paper over them.
