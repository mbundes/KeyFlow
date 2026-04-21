import Foundation
import AppKit

/// A per-application rule that determines fn key behavior.
struct AppRule: Codable, Identifiable, Sendable {
    var id: String { bundleID }
    let bundleID: String
    let appName: String
    var behavior: AppBehavior

    /// Returns the app icon from NSWorkspace (not stored/encoded).
    var icon: NSImage? {
        guard let url = NSWorkspace.shared.urlForApplication(
            withBundleIdentifier: bundleID
        ) else { return nil }
        return NSWorkspace.shared.icon(forFile: url.path(percentEncoded: false))
    }
}
