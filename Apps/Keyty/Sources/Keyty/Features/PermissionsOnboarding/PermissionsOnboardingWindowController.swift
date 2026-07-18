//
//  PermissionsOnboardingWindowController.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import SwiftUI

@MainActor
final class PermissionsOnboardingWindowController: NSWindowController {
    private let viewModel: PermissionsOnboardingViewModel

    var onCompletion: (() -> Void)? {
        get { self.viewModel.onCompletion }
        set { self.viewModel.onCompletion = newValue }
    }

    var needsOnboarding: Bool {
        self.viewModel.refresh()
        return !self.viewModel.isComplete
    }

    init(permissionsService: any PermissionsService) {
        let window = Window()
        let viewModel = PermissionsOnboardingViewModel(permissionsService: permissionsService)
        let hostingController = NSHostingController(rootView: PermissionsOnboardingView(viewModel: viewModel))
        window.contentViewController = hostingController

        self.viewModel = viewModel
        super.init(window: window)
        window.center()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(permissionsService:) instead.")
    }

    override func showWindow(_ sender: Any?) {
        self.window?.makeKeyAndOrderFront(sender)
        self.window?.center()
    }
}

// MARK: - Custom Window
extension PermissionsOnboardingWindowController {
    final class Window: NSWindow {
        private let titlebarToolbar = NSToolbar(identifier: "KeytyPermissionsOnboardingToolbar")

        init() {
            super.init(
                contentRect: NSRect(origin: .zero, size: Size.Window.permissionsOnboarding),
                styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
                backing: .buffered,
                defer: true
            )

            self.title = AppConstants.appName
            self.titleVisibility = .hidden
            self.titlebarAppearsTransparent = true
            self.isMovableByWindowBackground = true
            self.isReleasedWhenClosed = false
            self.minSize = self.frame.size
            self.maxSize = self.frame.size
            self.toolbarStyle = .unified

            self.titlebarToolbar.allowsUserCustomization = false
            self.titlebarToolbar.autosavesConfiguration = false
            self.titlebarToolbar.displayMode = .iconOnly
            self.titlebarToolbar.showsBaselineSeparator = false
            self.toolbar = self.titlebarToolbar
        }
    }
}
