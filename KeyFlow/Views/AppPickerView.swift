import SwiftUI
import AppKit

struct AppPickerView: View {
    var rulesManager: RulesManager
    var onBack: () -> Void

    @State private var searchText = ""
    @State fileprivate var installedApps: [AppInfo] = []

    fileprivate var filteredApps: [AppInfo] {
        if searchText.isEmpty {
            return installedApps
        }
        return installedApps.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.bundleID.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
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

                Text("Add App")
                    .font(.headline)

                Spacer()

                // Balance spacer
                Image(systemName: "chevron.left")
                    .font(.subheadline.weight(.semibold))
                    .hidden()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider().padding(.horizontal, 12)

            // Search
            TextField("Search...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)

            // App list (scrollable, fixed height)
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(filteredApps) { app in
                        Button {
                            rulesManager.setRule(
                                bundleID: app.bundleID,
                                appName: app.name,
                                behavior: .functionKeys
                            )
                            onBack()
                        } label: {
                            HStack(spacing: 10) {
                                Image(nsImage: app.icon)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text(app.name)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(maxHeight: 300)
        }
        .task {
            installedApps = Self.loadInstalledApps(existingRules: rulesManager.rules)
        }
    }

    /// Scans /Applications and running apps, excluding those with existing rules.
    private static func loadInstalledApps(existingRules: [AppRule]) -> [AppInfo] {
        let workspace = NSWorkspace.shared
        let existingIDs = Set(existingRules.map(\.bundleID))
        var appsByID: [String: AppInfo] = [:]

        // Running apps with regular activation policy
        for app in workspace.runningApplications where app.activationPolicy == .regular {
            if let bundleID = app.bundleIdentifier,
               let name = app.localizedName,
               let icon = app.icon,
               !existingIDs.contains(bundleID) {
                appsByID[bundleID] = AppInfo(bundleID: bundleID, name: name, icon: icon)
            }
        }

        // Scan /Applications
        let fileManager = FileManager.default
        if let urls = try? fileManager.contentsOfDirectory(
            at: URL(fileURLWithPath: "/Applications"),
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        ) {
            for url in urls where url.pathExtension == "app" {
                if let bundle = Bundle(url: url),
                   let bundleID = bundle.bundleIdentifier,
                   appsByID[bundleID] == nil,
                   !existingIDs.contains(bundleID) {
                    let name = fileManager.displayName(atPath: url.path)
                    let icon = workspace.icon(forFile: url.path)
                    appsByID[bundleID] = AppInfo(bundleID: bundleID, name: name, icon: icon)
                }
            }
        }

        return appsByID.values.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }
}

/// Lightweight struct for app picker display.
private struct AppInfo: Identifiable {
    var id: String { bundleID }
    let bundleID: String
    let name: String
    let icon: NSImage
}
