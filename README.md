# Automation Hub
 
A local-first, self-hosted alternative to Zapier/Make for macOS. A Dock app watches events across Airtable, Slack, and Notion, plus local Mac sources (Calendar, Reminders, files, mail), and runs rules connecting them — no third-party cloud dependency, and every execution logged locally for auditability.
 
## Status
 
Actively in development. Current build:
 
- [x] Scope integration rules & trigger schema
- [x] App shell (Dock window) + background rule service
- [ ] Keychain credential storage
- [ ] Airtable / Slack / Notion REST clients
- [ ] Local SQLite audit log
- [ ] Demo recording
## Architecture
 
- **UI**: SwiftUI, Dock-visible window with a rule list + editor.
- **Engine**: an in-process background service that keeps evaluating rules even when the window is closed (a full standalone LaunchAgent via `SMAppService` is a possible later step, not yet implemented).
- **Credentials**: macOS Keychain — no secrets ever touch disk in plain text or SQLite.
- **Storage**: SQLite, for the rule set and every execution's audit trail.
Every rule follows the same execution pipeline: **trigger detected → rule engine match → Keychain lookup (if needed) → action executes → result written to audit log.**
 
## Data model
 
```
erDiagram
  RULE ||--o{ EXECUTION : produces
  RULE }o--|| CREDENTIAL : uses
  RULE {
    uuid id PK
    string name
    string trigger_type
    string action_type
    boolean enabled
    datetime created_at
  }
  EXECUTION {
    uuid id PK
    uuid rule_id FK
    datetime triggered_at
    string status
    string detail
    integer duration_ms
  }
  CREDENTIAL {
    uuid id PK
    string service
    string keychain_ref
    datetime created_at
  }
```
 
Many rules can share one stored credential (e.g. multiple Airtable rules reusing the same personal access token). Only the `keychain_ref` pointer is stored in SQLite — the actual secret lives in Keychain.
 
## Event sources
 
| Source | Mechanism | Requires |
|---|---|---|
| Airtable | Poll | Personal access token (Keychain) + base/table IDs |
| Slack | Push (Socket Mode) | Bot token + app-level token (Keychain) |
| Notion | Poll | Internal integration token, shared per-page/database |
| Calendar | Push (EventKit) | One-time permission grant |
| Reminders | Push (EventKit) | One-time permission grant |
| Watched folder | Push (FSEvents) | Full Disk Access if outside Documents/Downloads |
| RSS feed | Poll | None |
| Plain webpage (no feed) | Poll (scraping) | None — fragile, breaks on layout changes |
| Weather | Poll | WeatherKit (paid Apple Developer account) or a free public API key (Keychain) |
| Mail | Push if IMAP IDLE supported, else poll | IMAP app-specific password (Keychain) |
| Clipboard | Poll only | None |
 
## Tech stack
 
Swift, SwiftUI, macOS Keychain, SQLite, EventKit, FSEvents, REST clients for Airtable/Slack/Notion.
 
## Requirements
 
- macOS 14+
- Xcode 16+
## Getting started
 
1. Clone the repo and open `automationhub.xcodeproj` in Xcode.
2. Build and run (⌘R).
3. Add a rule from the "+" button — note that until the Keychain, REST client, and SQLite tasks above are complete, rules are stored in memory only and don't yet trigger real actions.
