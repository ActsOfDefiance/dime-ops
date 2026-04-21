# Sprint Planning

How work gets sequenced and started.

## Sequencing Rules

1. **Epic order**: ops-setup -> dime-core -> dime-ui -> acts-of-defiance -> production
2. **Within an epic**: follow the dependency graph. Issues that unblock the most downstream work go first.
3. **Blocking decisions**: we prefer resolving decisions that block issues before starting unblocked work, even when unblocked paths are available. Clearing blockers creates more options.
4. **Parallel work**: independent issues within an epic can be worked in parallel.

## Starting Work

1. Check `/pm next` for the recommended issue with reasoning
2. The PM considers: epic priority, dependency graph, blocker count, current focus
3. You decide — the PM recommends, you choose

## Adjusting Priority

Priorities can shift when:
- A blocker is resolved, opening new paths
- External factors change urgency
- We learn something that reorders the work

When priority shifts, `/pm` updates `.claude/pm/priorities.md` to reflect the new focus.
