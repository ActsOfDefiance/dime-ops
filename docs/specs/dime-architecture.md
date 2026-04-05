# Dime — System Architecture

## Component Map

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                        │
│  Svelte/SvelteKit (local or cloud-hosted)                       │
│  Two-pane: Chat │ Contextual (research / draft / art studio)   │
│  Connects via REST + WebSocket only                             │
└─────────────────────────┬───────────────────────────────────────┘
                          │ REST + WS
┌─────────────────────────▼───────────────────────────────────────┐
│                        DIME API LAYER                           │
│  FastAPI · REST endpoints · WebSocket for real-time updates    │
│  Auth, roles, workflow routing, state machine                   │
│  Notification dispatch                                          │
└──────┬──────────────────┬────────────────────────┬─────────────┘
       │                  │                        │
       ▼                  ▼                        ▼
┌──────────────┐  ┌───────────────┐  ┌────────────────────────┐
│  PostgreSQL  │  │  BrokerAdapter│  │  FileSystemAdapter     │
│  Articles    │  │  (interface)  │  │  compendium/ · art/    │
│  State       │  │  ┌──────────┐ │  │  (local or GCS bucket) │
│  Users       │  │  │  Redis   │ │  └────────────────────────┘
│  Workflows   │  │  │  Rabbit  │ │
│  Audit log   │  │  │  GCP PS  │ │
└──────────────┘  │  └──────────┘ │
                  └───────┬───────┘
                          │ tasks / events
┌─────────────────────────▼───────────────────────────────────────┐
│                     DIME WORKER LAYER (ADK)                     │
│  ResearchAgent · WriterAgent · ArtDirectorAgent · ImageAgent   │
│  Publishes state change events back through broker             │
│  Writes to compendium/ and art/ via FileSystemAdapter          │
└──────────────────────────────────────────────────────────────────┘
                          │ signal
┌─────────────────────────▼───────────────────────────────────────┐
│                   PUBLISHING ADAPTER (interface)                │
│  AstroAdapter: copy files → astro build → deploy                │
│  FutureAdapter: POST to CMS API                                │
└─────────────────────────────────────────────────────────────────┘
```

## Adapter Interfaces

All infrastructure is hidden behind Python Protocols (structural typing). No concrete implementations leak across layer boundaries.

### BrokerAdapter
Task queue and event bus. Implementations: `RedisQueue`, `RabbitMQQueue`, `GCPPubSubQueue`. Selected by config — neither API nor worker imports a concrete broker.

### FileSystemAdapter
Abstracts local disk vs. GCS. Same interface regardless of where files land. Companion `VersioningAdapter` handles optional git integration (`GitVersioningAdapter` or `NullVersioningAdapter`).

### PublishingAdapter
Signal interface for publishing targets. See [dime-agents.md](dime-agents.md) for the full Protocol definition.

### NotificationAdapter
Out-of-band notification delivery. `InAppNotificationAdapter` (WebSocket, always active), `EmailNotificationAdapter`, `NullNotificationAdapter`. Future: Slack, SMS (Twilio).

## Key Design Rules

- Workers communicate back to the API exclusively via broker events — never direct API calls. This is the seam that allows future service separation.
- The state machine (pipeline transitions) lives in the API layer, not in an LLM.
- The Svelte UI renders the right pane based on `article.state` — it decides which component to mount, not the backend.
- Agents are workers, not orchestrators. They run, write output, emit a checkpoint event, exit.
