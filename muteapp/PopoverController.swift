import AppKit
import SwiftUI

@MainActor
final class PopoverController {
    private let popover: NSPopover
    private let host: NSHostingController<PopoverView>

    init() {
        host = NSHostingController(rootView: PopoverView())
        // Let SwiftUI's intrinsic content size drive the popover size.
        // Without this, NSHostingController falls back to a fixed preferredContentSize
        // that may be smaller (clipping) or taller (overflow off-screen) than reality.
        host.sizingOptions = [.preferredContentSize]

        popover = NSPopover()
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = host
    }

    func toggle(relativeTo view: NSView) {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: view.bounds, of: view, preferredEdge: .minY)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
