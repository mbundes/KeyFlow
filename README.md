# KeyFlow

**KeyFlow** is a lightweight macOS menu bar utility that automatically switches the Fn key mode (media keys vs. F1–F12 function keys) based on the active application.

![macOS](https://img.shields.io/badge/macOS-13%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![License](https://img.shields.io/badge/license-MIT-green)

## Features

- **Auto-switching** — KeyFlow detects which app is in focus and switches the Fn key mode accordingly
- **Per-app rules** — assign each app its own preferred mode: media keys or F1–F12
- **Instant toggle** — switch modes manually with a single click from the menu bar
- **Minimal UI** — lives entirely in the menu bar, no Dock icon
- **Persistent rules** — your configuration is saved and restored automatically

## Screenshots

| Media Mode | Function Keys Mode | App Rules |
|---|---|---|
| ![Media mode](Screenshots/screenshot_main_media.png?v=2) | ![Fn mode](Screenshots/screenshot_main_fn.png?v=2) | ![App Rules](Screenshots/screenshot_rules.png?v=2) |

## Requirements

- macOS 14 Sonoma or later
- Apple Silicon or Intel Mac

> **Note:** KeyFlow uses IOKit to control the Fn key hardware register. This requires the App Sandbox to be **disabled**, so KeyFlow cannot be distributed via the Mac App Store. It is distributed as a signed and notarized app outside the App Store.

## Installation

1. Download the latest `KeyFlow.app` from the [Releases](../../releases) page
2. Move it to your `/Applications` folder
3. Launch KeyFlow — the sun icon will appear in your menu bar
4. (Optional) Enable **Open at Login** from the menu

## Building from source

```bash
git clone https://github.com/YOUR_USERNAME/KeyFlow.git
cd KeyFlow
open KeyFlow.xcodeproj
```

Then build with **⌘B** in Xcode.

## How it works

KeyFlow uses:
- **IOKit HID** — reads and writes the `IOHIDFKeyMode` hardware register to switch Fn key modes
- **NSWorkspace notifications** — detects when the active application changes
- **SwiftUI + MenuBarExtra** — renders the menu bar popover UI
- **UserDefaults** — persists per-app rules across launches

## App Rules

In the **App Rules** screen you can add any installed app and assign it a mode:

| Mode | Icon | Description |
|------|------|-------------|
| Media Keys | ☀️ | F-row controls brightness, volume, playback |
| Function Keys | ⌨️ | F-row sends standard F1–F12 key codes |

Tap the mode badge to toggle. The global toggle on the main screen acts as the default for apps without a specific rule.

## License

MIT License — see [LICENSE](LICENSE) for details.

## Acknowledgements

Inspired by [Fluor](https://github.com/Pyroh/Fluor) by Pyroh.
