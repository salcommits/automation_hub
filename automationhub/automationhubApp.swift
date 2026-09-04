import SwiftUI
import AppKit

@main
struct AutomationHubApp: App {
    // Keeps the rule engine alive and stops the app from quitting when the
    // last window closes — the "background service" half of Task 2.
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        RuleEngineService.shared.start()
    }

    // This is the key line for "keeps evaluating rules even when the window
    // is closed": normally closing the last window quits a SwiftUI app.
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
}
