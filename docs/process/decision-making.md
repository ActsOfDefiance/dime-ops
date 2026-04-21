# Decision Making

How architectural and tooling decisions get made and recorded.

## Process

1. **Identify**: when an issue is blocked by an unresolved question, create a decision entry in `docs/decisions/open-decisions.md`
2. **Explore**: use the brainstorming skill for significant decisions. Document options with trade-offs.
3. **Discuss**: decisions are consensus-driven. The PM facilitates but does not decide unilaterally.
4. **Decide**: choose an option with clear rationale
5. **Record**: move the decision from `open-decisions.md` to `settled-decisions.md` with the rationale
6. **Unblock**: update dependent issues — remove `blocked` label, adjust priorities

## Decision Format

In `open-decisions.md`:
```markdown
## DECISION-NNN: Title

**Decision needed before:** [what it blocks]

**Options:**
- **A:** description
- **B:** description

**Considerations:** [context, constraints, trade-offs]
```

In `settled-decisions.md`:
```markdown
## DECISION-NNN: Title

**Decision:** [what was chosen]

**Why:** [rationale]
```

## Naming

Decisions are numbered sequentially: DECISION-001, DECISION-002, etc. Numbers are never reused.
