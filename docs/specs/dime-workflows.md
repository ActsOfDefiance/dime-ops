# Dime — Roles, Workflows & Notifications

## Workflow Presets

Workflow config is data, not code. Swapping from `solo` to `team` is a config change, not a deploy. Presets seed the `workflow_config` table on first run.

### `solo` (default)
All checkpoints assigned to project owner. In-app notifications active for all background task events. Out-of-band notification adapter is opt-in (default: null).

Setting `required: false` on any checkpoint causes dime to skip it and advance automatically — useful when you trust agent output for a stage.

### `team`
```
research_review  → researcher role
draft_review     → editor role
art_review       → art_director role
final_review     → editor role
publish          → editor or admin required
```
Notifications on assignment, completion, and errors. Email adapter active by default.

## Notifications

Notifications fire in **all** workflow configs including solo. Background tasks (deep research, image generation) can run for extended periods — completion events always surface to the user.

```python
class NotificationAdapter(Protocol):
    def notify(self, user: User, event: NotificationEvent) -> None: ...
```

| Adapter | Status |
|---|---|
| `InAppNotificationAdapter` | Always active — WebSocket push to UI |
| `EmailNotificationAdapter` | SMTP / SendGrid — opt-in |
| `NullNotificationAdapter` | Explicit silence — opt-in |
| `SlackNotificationAdapter` | Deferred — see open decisions |
| `SMSNotificationAdapter` | Deferred (Twilio) — see open decisions |

Events that always notify: task completion, checkpoint reached, publish success/failure, agent error.

`NotificationEvent` carries: `article_id`, `event_type`, `actor`, `message`.

## Roles

Built-in roles seeded on first run. Permissions stored as JSONB on the `role` table — extensible without schema changes.

| Role | Typical permissions |
|---|---|
| `admin` | All permissions |
| `editor` | approve_draft, edit_article, publish |
| `writer` | edit_article, submit_for_review |
| `reviewer` | approve_draft, comment |

## Deferred

Workflow config UI (settings screen for managing presets, role assignments, notification preferences) — see `docs/decisions/open-decisions.md` DECISION-005.
