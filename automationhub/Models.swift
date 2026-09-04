import Foundation

// Mirrors the RULE / EXECUTION / CREDENTIAL entities from the Data Model ERD.
// Kept as plain Codable structs for now — Task 5 (SQLite audit log) will add
// persistence on top of these, so the shapes matter more than storage right now.

struct Rule: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var triggerType: String   // e.g. "message_posted", "record_created", "event_start"
    var actionType: String    // e.g. "reminders_create_task", "slack_post_message"
    var enabled: Bool = true
    var createdAt: Date = Date()
}

struct Execution: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var ruleId: UUID          // FK -> Rule.id (not a second PK — fixing the ERD PDF's mislabel)
    var triggeredAt: Date = Date()
    var status: String        // "success" | "failed"
    var detail: String
    var durationMs: Int
}

struct Credential: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var service: String       // e.g. "slack", "airtable", "notion"
    var keychainRef: String   // pointer name only — actual secret lives in Keychain (Task 3)
    var createdAt: Date = Date()
}

// Placeholder option lists for the editor UI until real event sources (Task 4)
// are wired up. These come straight from the Event Sources doc.
enum TriggerOption: String, CaseIterable, Identifiable {
    case messagePosted = "message_posted"
    case recordCreated = "record_created"
    case recordUpdated = "record_updated"
    case pageUpdated = "page_updated"
    case eventStart = "event_start"
    case fileChanged = "file_changed"
    case newItem = "new_item"

    var id: String { rawValue }
}

enum ActionOption: String, CaseIterable, Identifiable {
    case slackPostMessage = "slack_post_message"
    case remindersCreateTask = "reminders_create_task"
    case airtableCreateRecord = "airtable_create_record"
    case notify = "notify"
    case auditLogOnly = "audit_log_only"

    var id: String { rawValue }
}
