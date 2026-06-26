# M4 — Reading Journey Design Spec

**Goal:** Track accepted chapter suggestions in M2's Journey Grid so they don't reappear across sessions. No server, no daily plans, no shared seeds.

## What Changes

### 1. Drift — `reading_history` Table
Add one table to the existing `AppDatabase`:

```
reading_history
├── id (INTEGER PRIMARY KEY AUTOINCREMENT)
├── book (TEXT) — Arabic book name
├── chapter (INTEGER)
├── category (TEXT) — "old_testament", "new_testament", "psalms", "prophets"
├── read_at (TEXT, ISO-8601 datetime)
└── UNIQUE(book, chapter)
```

Schema version bumped to 2 with `onUpgrade` migration.

### 2. Repository — `ReadingJourneyRepository`
- `addReadEntry(book, chapter, category)` — inserts into `reading_history`
- `getAllReadEntries()` — returns all entries (for exclusion logic)
- Uses Drift DAO pattern

### 3. Updated `BibleRandomizerService`
- `randomForCategory(category, {Set<String>? exclude})` — excludes already-read `"book:chapter"` pairs
- Same deterministic PRNG, just filters out the exclude set

### 4. Journey Grid Integration
- On "موافق" (accept), call `ReadingJourneyRepository.addReadEntry()` before launching Coptic Reader
- Load existing history on widget init to pass to randomizer
- No change to the dialog UI

### What's NOT built (per user choice)
- No history list UI page
- No daily scheduled generation
- No network sync
- No user-specific seeds
