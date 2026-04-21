import SwiftUI

struct RuleListView: View {
    var rulesManager: RulesManager
    var onBack: () -> Void
    var onAdd: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header with back and add buttons
            HStack {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.subheadline.weight(.semibold))
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Spacer()

                Text("App Rules")
                    .font(.headline)

                Spacer()

                Button {
                    onAdd()
                } label: {
                    Image(systemName: "plus")
                        .font(.subheadline.weight(.semibold))
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)

            Divider().padding(.horizontal, 8)

            if rulesManager.rules.isEmpty {
                // Empty state
                VStack(spacing: 8) {
                    Image(systemName: "list.bullet")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    Text("No rules yet")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Add apps to control their\nFn key behavior")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 24)
            } else {
                // Rules list (scrollable, max height limited)
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(rulesManager.rules.enumerated()), id: \.element.id) { index, rule in
                            if index > 0 {
                                Divider().padding(.leading, 42)
                            }
                            ruleRow(rule: rule)
                        }
                    }
                }
                .frame(maxHeight: 300)

                Divider().padding(.horizontal, 8)

                HStack {
                    Spacer()
                    Text("Tap + to add an app rule")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.vertical, 10)
            }
        }
    }

    private func ruleRow(rule: AppRule) -> some View {
        HStack(spacing: 6) {
            if let icon = rule.icon {
                Image(nsImage: icon)
                    .resizable()
                    .frame(width: 24, height: 24)
            } else {
                Image(systemName: "app")
                    .font(.body)
                    .frame(width: 24, height: 24)
            }

            Text(rule.appName.hasSuffix(".app") ? String(rule.appName.dropLast(4)) : rule.appName)
                .font(.subheadline)
                .lineLimit(1)

            Spacer(minLength: 4)

            // Mode indicator pill + delete — grouped tight on the right
            HStack(spacing: 4) {
                Button {
                    let newBehavior: AppBehavior = rule.behavior == .functionKeys ? .media : .functionKeys
                    rulesManager.setRule(
                        bundleID: rule.bundleID,
                        appName: rule.appName,
                        behavior: newBehavior
                    )
                } label: {
                    Image(systemName: rule.behavior == .functionKeys ? "keyboard" : "sun.max.fill")
                        .font(.caption2)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 4)
                        .background(
                            rule.behavior == .functionKeys
                                ? fnOrange.opacity(0.2)
                                : Color.blue.opacity(0.2),
                            in: Capsule()
                        )
                        .foregroundStyle(rule.behavior == .functionKeys ? fnOrange : .blue)
                }
                .buttonStyle(.plain)

                Button {
                    rulesManager.removeRule(bundleID: rule.bundleID)
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 20, height: 20)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, 4)
        .padding(.vertical, 6)
    }
}
