import SwiftUI

@main
struct KeyFlowApp: App {
    @State private var fnKeyManager = FnKeyManager()
    @State private var appMonitor = AppMonitor()
    @State private var rulesManager = RulesManager()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(
                fnKeyManager: fnKeyManager,
                appMonitor: appMonitor,
                rulesManager: rulesManager
            )
        } label: {
            VStack(spacing: 1) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 9))
                Text("Fn")
                    .font(.system(size: 7, weight: .heavy, design: .rounded))
            }
        }
        .menuBarExtraStyle(.window)


    }
}
