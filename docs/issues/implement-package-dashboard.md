# Issue: Implement Package Dashboard

**Type:** feature
**Repo:** dime-ui
**Epic:** epic-dime-ui
**Blocked by:** implement-right-pane (mounted as the `final_review` state view)

## What it is

The Package Dashboard is the `final_review` right-pane view. It gives the human a complete picture of the article package before approving publication: rendered content, all image slots at their target display dimensions, metadata, and action buttons.

This is NOT a site preview (that would require a running Astro dev server). It's an article package review — similar to a print proof.

## Sections

### Article preview
- Rendered markdown (HTML, not raw markdown)
- Correct typography and prose styling
- Footnotes/citations rendered
- Estimated word count + reading time

### Image slots
- All image slots displayed at their target dimensions (not just thumbnails)
- Alt text shown below each image
- Slot role label (hero, thumbnail, inline, etc.)
- "Regenerate" button per slot → triggers `POST /articles/{id}/image-slots/{slot}/regenerate`
- Regenerating shows a spinner in that slot while new image generates

### Metadata panel
- Article title, type, tags
- Project name
- Word count
- Source count (from research notes)
- Target publish date (if set)

### Actions
- **Approve** → `POST /articles/{id}/approve` → state transitions to `publishing`
- **Request changes** → opens a comment field → `POST /articles/{id}/reject` with note → state returns to appropriate earlier state
- **Edit article** → shortcut to return to `writing_review` state

## Notes

If `PublishingAdapter.preview_url()` returns a URL (e.g., local Astro dev server is running), show a "Preview on site" link as progressive enhancement. Don't require it.

## Acceptance criteria

- [ ] Renders article markdown as HTML (use a markdown renderer, not raw innerHTML)
- [ ] All image slots shown at correct dimensions (use CSS to enforce — not browser default)
- [ ] Regenerate per slot works end-to-end: API call → WebSocket event → spinner → new image
- [ ] Approve and Request changes call correct API endpoints
- [ ] Request changes requires a non-empty comment before submitting
- [ ] Storybook story: Package Dashboard with sample article + all image slot states (loading, done, error)
