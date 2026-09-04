import SwiftUI

struct ContentView: View {
    @ObservedObject private var engine = RuleEngineService.shared
    @State private var showingEditor = false

    var body: some View {
        NavigationStack {
            List {
                if engine.rules.isEmpty {
                    ContentUnavailableView(
                        "No rules yet",
                        systemImage: "bolt.horizontal.circle",
                        description: Text("Add a rule to start watching Airtable, Slack, or Notion.")
                    )
                } else {
                    ForEach(engine.rules) { rule in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(rule.name).font(.headline)
                                Spacer()
                                Circle()
                                    .fill(rule.enabled ? .green : .gray)
                                    .frame(width: 8, height: 8)
                            }
                            Text("\(rule.triggerType) → \(rule.actionType)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                engine.deleteRule(rule)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Automation Hub")
            .toolbar {
                ToolbarItem {
                    Button {
                        showingEditor = true
                    } label: {
                        Label("New Rule", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigation) {
                    if let lastTick = engine.lastTick {
                        Text("Last check: \(lastTick.formatted(date: .omitted, time: .standard))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .sheet(isPresented: $showingEditor) {
                RuleEditorView { newRule in
                    engine.addRule(newRule)
                }
            }
        }
        .onAppear {
            engine.start()
        }
    }
}

#Preview {
    ContentView()
}
