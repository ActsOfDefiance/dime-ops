# Issue #15 — Pluggable Adapters: Implementation Plan

## Branch
`feature/015-pluggable-adapters`

## Files to Create

| File | Purpose |
|---|---|
| `dime/adapters/protocols.py` | All 4 Protocol definitions |
| `dime/adapters/broker/redis.py` | RedisBrokerAdapter (async Redis Streams) |
| `dime/adapters/broker/rabbitmq.py` | RabbitMQBrokerAdapter stub |
| `dime/adapters/broker/gcppubsub.py` | GCPPubSubBrokerAdapter stub |
| `dime/adapters/filesystem/local.py` | LocalFileSystemAdapter (pathlib) |
| `dime/adapters/filesystem/gcs.py` | GCSFileSystemAdapter |
| `dime/adapters/publishing/hugo.py` | HugoPublishingAdapter (JSON frontmatter) |
| `dime/adapters/notification/websocket.py` | WebSocketNotificationAdapter |
| `dime/adapters/factory.py` | AdapterSet dataclass + build_adapters() |
| `dime/adapters/__init__.py` | Re-exports |
| `tests/test_adapters.py` | Unit + integration tests |

## Key Decisions
- FileSystemAdapter: sync (GCS lib is sync)
- BrokerAdapter: async (Redis Streams via redis.asyncio)
- Hugo frontmatter: JSON format (no pyyaml dep)
- Factory: build_adapters(settings) -> AdapterSet
- No mocking in integration tests (past incident)
- GCS tests gated on GCS_TEST_BUCKET env var
