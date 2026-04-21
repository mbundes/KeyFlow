import IOKit
import IOKit.hid
import Foundation

/// Manages reading and writing the macOS fn key mode via IOKit.
@Observable
final class FnKeyManager {
    private(set) var currentMode: FnKeyMode = .media

    /// Reads the current fn key mode from the IOKit registry.
    func readCurrentMode() -> FnKeyMode? {
        let entry = IORegistryEntryFromPath(
            kIOMainPortDefault,
            "IOService:/IOResources/IOHIDSystem"
        )
        guard entry != MACH_PORT_NULL else { return nil }
        defer { IOObjectRelease(entry) }

        guard let property = IORegistryEntryCreateCFProperty(
            entry,
            "HIDParameters" as CFString,
            kCFAllocatorDefault,
            0
        ) else { return nil }

        guard let params = property.takeRetainedValue() as? [String: Any],
              let modeValue = params["HIDFKeyMode"] as? Int,
              let mode = FnKeyMode(rawValue: modeValue)
        else { return nil }

        return mode
    }

    /// Sets the fn key mode via IOKit HID parameter.
    @discardableResult
    func setMode(_ mode: FnKeyMode) -> Bool {
        let entry = IORegistryEntryFromPath(
            kIOMainPortDefault,
            "IOService:/IOResources/IOHIDSystem"
        )
        guard entry != MACH_PORT_NULL else { return false }
        defer { IOObjectRelease(entry) }

        var connect: io_connect_t = 0
        let openResult = IOServiceOpen(
            entry,
            mach_task_self_,
            UInt32(kIOHIDParamConnectType),
            &connect
        )
        guard openResult == KERN_SUCCESS else { return false }
        defer { IOServiceClose(connect) }

        let value = mode.rawValue as CFNumber
        let setResult = IOHIDSetCFTypeParameter(
            connect,
            kIOHIDFKeyModeKey as CFString,
            value
        )

        if setResult == KERN_SUCCESS {
            currentMode = mode
            return true
        }
        return false
    }

    /// Refreshes currentMode from the system.
    func refresh() {
        if let mode = readCurrentMode() {
            currentMode = mode
        }
    }
}
