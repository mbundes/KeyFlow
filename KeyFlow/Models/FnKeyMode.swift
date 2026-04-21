import Foundation

/// Represents the two physical fn key modes controlled via IOKit.
enum FnKeyMode: Int, Codable, CaseIterable, Sendable {
    case media = 0
    case functionKeys = 1

    var displayName: String {
        switch self {
        case .media: "Media Keys"
        case .functionKeys: "F1-F12 Keys"
        }
    }

    var systemImage: String {
        switch self {
        case .media: "speaker.wave.2"
        case .functionKeys: "keyboard"
        }
    }
}
