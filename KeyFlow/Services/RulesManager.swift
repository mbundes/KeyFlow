import Foundation

/// Manages per-app fn key behavior rules, persisted in UserDefaults.
@Observable
final class RulesManager {
    private static let rulesKey = "appRules"
    private static let defaultModeKey = "defaultFnKeyMode"
    private static let switchingEnabledKey = "switchingEnabled"

    private(set) var rules: [AppRule] = []

    var defaultMode: FnKeyMode {
        didSet { saveDefaultMode() }
    }

    var switchingEnabled: Bool {
        didSet { saveSwitchingEnabled() }
    }

    init() {
        self.defaultMode = FnKeyMode(
            rawValue: UserDefaults.standard.integer(forKey: Self.defaultModeKey)
        ) ?? .media
        self.switchingEnabled = UserDefaults.standard.object(
            forKey: Self.switchingEnabledKey
        ) as? Bool ?? true
        loadRules()
    }

    /// Returns the behavior for a given bundle ID, or .inferred if no rule exists.
    func behavior(for bundleID: String) -> AppBehavior {
        rules.first { $0.bundleID == bundleID }?.behavior ?? .inferred
    }

    /// Resolves the effective FnKeyMode for a given bundle ID.
    func resolvedMode(for bundleID: String) -> FnKeyMode {
        behavior(for: bundleID).resolved(withDefault: defaultMode)
    }

    /// Sets (or creates) a rule for the given app.
    func setRule(bundleID: String, appName: String, behavior: AppBehavior) {
        if let index = rules.firstIndex(where: { $0.bundleID == bundleID }) {
            rules[index].behavior = behavior
        } else {
            rules.append(AppRule(
                bundleID: bundleID,
                appName: appName,
                behavior: behavior
            ))
        }
        saveRules()
    }

    /// Removes the rule for the given bundle ID.
    func removeRule(bundleID: String) {
        rules.removeAll { $0.bundleID == bundleID }
        saveRules()
    }

    // MARK: - Persistence

    private func loadRules() {
        guard let data = UserDefaults.standard.data(forKey: Self.rulesKey),
              let decoded = try? JSONDecoder().decode([AppRule].self, from: data)
        else { return }
        rules = decoded
    }

    private func saveRules() {
        guard let data = try? JSONEncoder().encode(rules) else { return }
        UserDefaults.standard.set(data, forKey: Self.rulesKey)
    }

    private func saveDefaultMode() {
        UserDefaults.standard.set(defaultMode.rawValue, forKey: Self.defaultModeKey)
    }

    private func saveSwitchingEnabled() {
        UserDefaults.standard.set(switchingEnabled, forKey: Self.switchingEnabledKey)
    }
}
