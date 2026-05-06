import AppKit

@MainActor
final class AppHolder {
    static let shared = AppHolder()
    let delegate = AppDelegate()
}

MainActor.assumeIsolated {
    let app = NSApplication.shared
    app.delegate = AppHolder.shared.delegate
    app.setActivationPolicy(.accessory)
}
NSApplication.shared.run()
