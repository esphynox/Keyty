//
//  PointerIconVisualizerWindow.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import Combine

final class PointerIconVisualizerWindow: NSWindow {
    private let settings: any PointerIconSettingsProtocol & ReactiveSettings
    private var cancellables = Set<AnyCancellable>()

    init(settings: any PointerIconSettingsProtocol & ReactiveSettings) {
        self.settings = settings
        super.init(
            contentRect: NSRect(origin: .zero, size: PointerIconContentView.windowSize(settings: settings)),
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        self.level = .screenSaver
        self.isOpaque = false
        self.backgroundColor = .clear
        self.alphaValue = 1
        self.ignoresMouseEvents = true
        self.collectionBehavior = .canJoinAllSpaces

        settings.changes
            .sink { [weak self] in
                Task { @MainActor in
                    self?.settingsDidChange()
                }
            }
            .store(in: &self.cancellables)
    }

    private func settingsDidChange() {
        let newSize = PointerIconContentView.windowSize(settings: self.settings)
        self.setContentSize(newSize)
        self.contentView?.needsDisplay = true
        self.update(screenLocation: NSEvent.mouseLocation)
        self.refreshVisibility()
    }

    static func make(settings: any PointerIconSettingsProtocol & ReactiveSettings) -> PointerIconVisualizerWindow {
        let window = PointerIconVisualizerWindow(settings: settings)
        let contentView = PointerIconContentView(settings: settings)
        contentView.visibilityDidChange = { [weak window] _ in
            window?.refreshVisibility()
        }
        window.contentView = contentView
        return window
    }

    func update(screenLocation: NSPoint) {
        let size = frame.size
        let origin = self.settings.anchor.origin(relativeTo: screenLocation, windowSize: size, offset: self.settings.offset)
        self.setFrameOrigin(origin)
    }

    func update(mouseEvent: MouseEvent) {
        (contentView as? PointerIconContentView)?.handle(mouseEvent: mouseEvent)
        self.refreshVisibility()
    }

    func refreshVisibility() {
        let isTransientlyVisible = (contentView as? PointerIconContentView)?.isTransientlyVisible ?? false
        if self.settings.isEnabled, self.settings.alwaysVisible || isTransientlyVisible {
            orderFrontRegardless()
        } else {
            orderOut(nil)
        }
    }
}

private extension PointerIconAnchor {
    func origin(relativeTo cursor: NSPoint, windowSize: NSSize, offset: CGFloat) -> NSPoint {
        switch self {
        case .bottomRight:
            return NSPoint(x: cursor.x + offset, y: cursor.y - windowSize.height - offset)
        case .bottomLeft:
            return NSPoint(x: cursor.x - windowSize.width - offset, y: cursor.y - windowSize.height - offset)
        case .topRight:
            return NSPoint(x: cursor.x + offset, y: cursor.y + offset)
        case .topLeft:
            return NSPoint(x: cursor.x - windowSize.width - offset, y: cursor.y + offset)
        }
    }
}
