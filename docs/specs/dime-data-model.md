# Dime — Data Model

PostgreSQL schema. Content blobs do **not** live in the database — the filesystem is canonical for article content (see `decisions/open-decisions.md` DECISION-001 for versioning strategy).

## Tables

### `project`
| Column | Type | Notes |
|---|---|---|
| id | uuid pk | |
| name | text | |
| slug | text unique | |
| style_guide | jsonb | image slots (name, width, height, format), style tokens, palette |
| content_guide | jsonb | editorial config: audience, tone, voice, quality standards — injected into WriterAgent and ResearchAgent context |
| workflow_config_id | uuid fk | → workflow_config |
| default_adapter | text | registered adapter key e.g. `"hugo"` |
| created_at | timestamptz | |

`content_guide` shape (editable per project — different publications have different voices):
```json
{
  "audience": {
    "demographics": "Liberal adults 20-40",
    "reading_level": "Flesch-Kincaid grade 8-12",
    "assumed_knowledge": "Lay interest, no prior specialisation required"
  },
  "voice": {
    "tone": "Casual but intelligent, engaging, not academic",
    "pov": "Third person, historically grounded",
    "sensitivity": "Handle controversial topics with transparency about perspective"
  },
  "standards": {
    "min_sources": 3,
    "prefer_primary_sources": true,
    "citation_style": "inline footnotes",
    "accuracy_threshold": 0.99
  },
  "article_types": {
    "profile": { "min_words": 800, "max_words": 1500 },
    "movement_summary": { "min_words": 1000, "max_words": 2000 }
  }
}
```

### `article`
| Column | Type | Notes |
|---|---|---|
| id | uuid pk | |
| project_id | uuid fk | → project |
| title | text | |
| slug | text | |
| state | enum | all states from pipeline spec |
| topic_brief | text | initial brief submitted at queue time |
| tags | text[] | |
| assigned_to | uuid fk null | → user |
| current_draft_id | uuid fk null | → article_checkpoint |
| created_at | timestamptz | |
| published_at | timestamptz null | |

### `article_checkpoint` *(lightweight — pointers, not content blobs)*
| Column | Type | Notes |
|---|---|---|
| id | uuid pk | |
| article_id | uuid fk | → article |
| state_at_checkpoint | enum | |
| git_commit_hash | text null | populated when VersioningAdapter is GitAdapter |
| content_snapshot | text null | populated only at publish time (forensic copy) |
| created_by | uuid fk | → user |
| note | text null | |
| created_at | timestamptz | |

### `image_slot`
Seeded from `project.style_guide` when article is created.

| Column | Type | Notes |
|---|---|---|
| id | uuid pk | |
| article_id | uuid fk | → article |
| slot_name | text | `hero`, `thumbnail`, `og_image`, etc. |
| width, height | int | from style guide |
| format | text | |
| approved_prompt | text null | prompt approved by human in art_review |
| selected_variant_id | uuid fk null | → image_variant |

### `image_variant`
| Column | Type | Notes |
|---|---|---|
| id | uuid pk | |
| slot_id | uuid fk | → image_slot |
| file_path | text | relative to `art/` |
| prompt_used | text | actual prompt sent to provider |
| provider | text | `imagen3`, etc. |
| generation_meta | jsonb | seed, model version, parameters |
| created_at | timestamptz | |

### `publish_event`
| Column | Type | Notes |
|---|---|---|
| id | uuid pk | |
| article_id | uuid fk | → article |
| article_checkpoint_id | uuid fk | → article_checkpoint (which version was published) |
| adapter_name | text | |
| adapter_version | text | |
| target_url | text null | |
| published_by | uuid fk | → user |
| published_at | timestamptz | |
| metadata | jsonb | adapter-specific publish details |

### `user`
| Column | Type | Notes |
|---|---|---|
| id | uuid pk | |
| email | text unique | |
| display_name | text | |
| role_id | uuid fk | → role |
| created_at | timestamptz | |

### `role`
| Column | Type | Notes |
|---|---|---|
| id | uuid pk | |
| name | text unique | built-in: `admin`, `editor`, `writer`, `reviewer` |
| permissions | jsonb | `{approve_draft, edit_article, publish, manage_users, ...}` |

### `workflow_config`
| Column | Type | Notes |
|---|---|---|
| id | uuid pk | |
| name | text | e.g. `solo`, `team` |
| is_default | bool | |
| checkpoints | jsonb | see below |
| notification_rules | jsonb | |

`checkpoints` shape:
```json
{
  "research_review":  { "required": true, "assignee_role": "owner" },
  "draft_review":     { "required": true, "assignee_role": "editor" },
  "art_review":       { "required": true, "assignee_role": "owner" },
  "final_review":     { "required": true, "assignee_role": "editor" },
  "auto_publish":     false
}
```

Setting `"required": false` on any checkpoint causes dime to advance automatically — useful when you trust agent output for a given stage.
