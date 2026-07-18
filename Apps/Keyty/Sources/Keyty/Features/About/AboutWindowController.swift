//
//  AboutWindowController.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import SwiftUI

@MainActor
final class AboutWindowController: NSWindowController {
    init(bundle: Bundle = .main) {
        let window = Window()
        let viewModel = AboutWindowViewModel(bundle: bundle)
        let rootView = AboutWindowView(viewModel: viewModel)
        window.contentViewController = NSHostingController(rootView: rootView)

        super.init(window: window)
        window.center()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(bundle:) instead.")
    }

    override func showWindow(_ sender: Any?) {
        self.window?.makeKeyAndOrderFront(sender)
    }
}

// MARK: - Custom Window
extension AboutWindowController {
    final class Window: NSWindow {
        private let titlebarToolbar = NSToolbar(identifier: "KeytyAboutToolbar")

        init() {
            super.init(
                contentRect: NSRect(origin: .zero, size: Size.Window.about),
                styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
                backing: .buffered,
                defer: true
            )

            self.title = AppConstants.appName
            self.titleVisibility = .hidden
            self.titlebarAppearsTransparent = true
            self.isMovableByWindowBackground = true
            self.isReleasedWhenClosed = false
            self.minSize = Size.Window.about
            self.maxSize = Size.Window.about
            self.toolbarStyle = .unified

            self.titlebarToolbar.allowsUserCustomization = false
            self.titlebarToolbar.autosavesConfiguration = false
            self.titlebarToolbar.displayMode = .iconOnly
            self.titlebarToolbar.showsBaselineSeparator = false
            self.toolbar = self.titlebarToolbar
        }
    }
}
