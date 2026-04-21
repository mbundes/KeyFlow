import AppKit
import Foundation

/// Monitors the currently active application using NSWorkspace notifications.
@Observable
final class AppMonitor {
    private(set) var activeAppBundleID: String?
    private(set) var activeAppName: String?
    private(set) var activeAppIcon: NSImage?

    private var observer: Any?

    /// Called when the active app changes. Receives the bundle ID.
    var onAppChange: ((String) -> Void)?

    func start() {
        if let app = NSWorkspace.shared.frontmostApplication {
            updateActiveApp(app)
        }

        observer = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let app = notification.userInfo?[
                NSWorkspace.applicationUserInfoKey
            ] as? NSRunningApplication else { return }
            self?.updateActiveApp(app)
        }
    }

    func stop() {
        if let observer {
            NSWorkspace.shared.notificationCenter.removeObserver(observer)
        }
        observer = nil
    }

    private func updateActiveApp(_ app: NSRunningApplication) {
        let bundleID = app.bundleIdentifier ?? "unknown"
        activeAppBundleID = bundleID
        activeAppName = app.localizedName
        activeAppIcon = app.icon
        onAppChange?(bundleID)
    }
}
