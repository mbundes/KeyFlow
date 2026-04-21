import Foundation

/// Defines what fn key behavior to apply when an app is active.
enum AppBehavior: String, Codable, CaseIterable, Sendable {
    case inferred
    case media
    case functionKeys

    var displayName: String {
        switch self {
        case .inferred: "Use Default"
        case .media: "Media Keys"
        case .functionKeys: "F1-F12 Keys"
        }
    }

    var systemImage: String {
        switch self {
        case .inferred: "arrow.uturn.backward"
        case .media: "speaker.wave.2"
        case .functionKeys: "keyboard"
        }
    }

    /// Resolves this behavior to a concrete FnKeyMode, using
    /// the provided default when the behavior is .inferred.
    func resolved(withDefault defaultMode: FnKeyMode) -> FnKeyMode {
        switch self {
        case .inferred: defaultMode
        case .media: .media
        case .functionKeys: .functionKeys
        }
    }
}
