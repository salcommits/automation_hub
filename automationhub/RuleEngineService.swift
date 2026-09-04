import Foundation
import Combine

// The "background rule service" half of Task 2.
//
// For now this is an in-process engine that keeps ticking on a timer whether
// or not the window is open — it does NOT yet evaluate real triggers (that's
// Task 4, once the Airtable/Slack/Notion clients and EventKit/FSEvents
// listeners exist). This is deliberately a stub so the app shell has
// something real to hold onto.
//
// True "survives a full app quit" behavior would mean registering a separate
// executable as a LaunchAgent via SMAppService — noted as a possible later
// task, not implemented here.

final class RuleEngineService: ObservableObject {
    static let shared = RuleEngineService()

    @Published var rules: [Rule] = []
    @Published var lastTick: Date?
    @Published var isRunning: Bool = false

    private var timer: Timer?

    private init() {}

    func start() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.evaluateRules()
        }
        evaluateRules() // run once immediately on start
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func addRule(_ rule: Rule) {
        rules.append(rule)
    }

    func deleteRule(_ rule: Rule) {
        rules.removeAll { $0.id == rule.id }
    }

    // Stub — Task 4 will replace this with real trigger matching against
    // live events instead of just a timestamp tick.
    private func evaluateRules() {
        lastTick = Date()
        for rule in rules where rule.enabled {
            // No-op for now. Once real triggers exist, this is where each
            // enabled rule gets checked against incoming events, then
            // Task 3 (Keychain) and Task 5 (audit log) get called from here.
            _ = rule
        }
    }
}
