import SwiftUI

struct RuleEditorView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var triggerType: TriggerOption = .messagePosted
    @State private var actionType: ActionOption = .remindersCreateTask
    @State private var enabled: Bool = true

    var onSave: (Rule) -> Void

    var body: some View {
        Form {
            Section("Rule") {
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)

                Picker("Trigger", selection: $triggerType) {
                    ForEach(TriggerOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }

                Picker("Action", selection: $actionType) {
                    ForEach(ActionOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }

                Toggle("Enabled", isOn: $enabled)
            }

            Section {
                HStack {
                    Spacer()
                    Button("Cancel") { dismiss() }
                    Button("Save") {
                        let rule = Rule(
                            name: name.isEmpty ? "Untitled rule" : name,
                            triggerType: triggerType.rawValue,
                            actionType: actionType.rawValue,
                            enabled: enabled
                        )
                        onSave(rule)
                        dismiss()
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
        }
        .padding()
        .frame(minWidth: 380, minHeight: 260)
    }
}

#Preview {
    RuleEditorView(onSave: { _ in })
}
