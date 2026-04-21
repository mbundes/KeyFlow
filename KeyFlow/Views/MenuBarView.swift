import SwiftUI

// MARK: - Shared color constant

let fnOrange = Color(red: 240/255, green: 150/255, blue: 54/255)

// MARK: - Custom colored toggle

struct ColoredToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color

    func makeBody(configuration: Configuration) -> some View {
        let isOn = configuration.isOn
        Capsule()
            .fill(isOn ? onColor : offColor)
            .frame(width: 40, height: 24)
            .overlay(
                Circle()
                    .fill(.white)
                    .shadow(radius: 1)
                    .frame(width: 20, height: 20)
                    .offset(x: isOn ? 8 : -8),
                alignment: .center
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    configuration.isOn.toggle()
                }
            }
    }
}

// MARK: - Navigation state

enum MenuScreen {
    case main
    case rules
    case addApp
}

// MARK: - MenuBarView

struct MenuBarView: View {
    var fnKeyManager: FnKeyManager
    var appMonitor: AppMonitor
    var rulesManager: RulesManager

    @State private var screen: MenuScreen = .main

    var body: some View {
        ZStack {
            switch screen {
            case .main:
                mainView
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .leading)
                    ))
            case .rules:
                RuleListView(
                    rulesManager: rulesManager,
                    onBack: { withAnimation(.easeInOut(duration: 0.2)) { screen = .main } },
                    onAdd: { withAnimation(.easeInOut(duration: 0.2)) { screen = .addApp } }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .trailing)
                ))
            case .addApp:
                AppPickerView(
                    rulesManager: rulesManager,
                    onBack: { withAnimation(.easeInOut(duration: 0.2)) { screen = .rules } }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .trailing)
                ))
            }
        }
        .frame(width: 220)
        .onAppear { screen = .main }
    }

    private var mainView: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 4)

            // 1. Large centered icon — changes based on mode
            if fnKeyManager.currentMode == .media {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(.blue)
                    .frame(height: 60)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(fnOrange)
                        .frame(width: 56, height: 56)
                    Text("F1")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.black)
                }
                .frame(height: 60)
            }

            // 2. Toggle slider — custom colored
            Toggle(isOn: modeBinding) {
                EmptyView()
            }
            .toggleStyle(ColoredToggleStyle(onColor: .blue, offColor: fnOrange))

            Divider().padding(.horizontal, 16)

            // 3. App Rules button
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { screen = .rules }
            } label: {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("App Rules")
                }
                .font(.subheadline.weight(.medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)

            Divider().padding(.horizontal, 16)

            // 4. Exit button
            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                HStack {
                    Image(systemName: "xmark.circle")
                    Text("Exit")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)

            Spacer().frame(height: 4)
        }
        .task {
            setupAppMonitoring()
        }
    }

    private var modeBinding: Binding<Bool> {
        Binding(
            get: { fnKeyManager.currentMode == .media },
            set: { isMedia in
                let mode: FnKeyMode = isMedia ? .media : .functionKeys
                fnKeyManager.setMode(mode)
            }
        )
    }

    private func setupAppMonitoring() {
        fnKeyManager.refresh()
        appMonitor.onAppChange = { bundleID in
            guard rulesManager.switchingEnabled else { return }
            let mode = rulesManager.resolvedMode(for: bundleID)
            fnKeyManager.setMode(mode)
        }
        appMonitor.start()
    }
}
