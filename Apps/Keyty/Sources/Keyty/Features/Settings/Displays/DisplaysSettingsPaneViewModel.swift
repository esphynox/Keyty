//
//  DisplaysSettingsPaneViewModel.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Combine
import SwiftUI

final class DisplaysSettingsPaneViewModel: ObservableObject {
    private let screensService: any ScreenServiceProvider
    private let keyboardVisualizerSettings: KeyboardVisualizerSettings
    private var cancellables = Set<AnyCancellable>()

    let paddingRange: ClosedRange<Double> = Double(KeyboardVisualizerSettings.minWindowPadding)...Double(KeyboardVisualizerSettings.maxWindowPadding)
    let paddingStep: Double = Double(Spacing.md)

    @Published private(set) var screens: [Screen]

    @Published var selectedScreen: Screen {
        didSet { self.keyboardVisualizerSettings.screenID = self.selectedScreen.id }
    }

    var selectedScreenID: CGDirectDisplayID {
        get { self.selectedScreen.id }
        set { self.selectedScreen = self.resolveSelectedScreen(for: newValue) }
    }

    @Published var selectedAnchor: KeyboardVisualizerAnchor {
        didSet { self.keyboardVisualizerSettings.anchor = self.selectedAnchor }
    }

    @Published var windowPadding: Double {
        didSet { self.keyboardVisualizerSettings.windowPadding = CGFloat(self.windowPadding) }
    }

    var stackAxis: KeyboardVisualizerStackAxis {
        self.keyboardVisualizerSettings.stackAxis
    }

    init(
        screensService: any ScreenServiceProvider = ScreensService.shared,
        keyboardVisualizerSettings: KeyboardVisualizerSettings = KeyboardVisualizerSettings()
    ) {
        guard let selectedScreen = Self.initialSelectedScreen(
            screensService: screensService,
            keyboardVisualizerSettings: keyboardVisualizerSettings
        ) else {
            preconditionFailure("DisplaysSettingsPaneViewModel requires at least one available screen")
        }

        self.screensService = screensService
        self.keyboardVisualizerSettings = keyboardVisualizerSettings
        self.screens = screensService.screens
        self.selectedScreen = selectedScreen
        self.selectedAnchor = keyboardVisualizerSettings.anchor
        self.windowPadding = Double(keyboardVisualizerSettings.windowPadding)

        self.screensService.screensDidChange
            .receive(on: RunLoop.main)
            .sink { [weak self] screens in
                guard let self else { return }
                self.screens = screens
                self.selectedScreen = self.resolveSelectedScreen(for: self.keyboardVisualizerSettings.screenID)
            }
            .store(in: &self.cancellables)
    }
}

private extension DisplaysSettingsPaneViewModel {
    static func initialSelectedScreen(
        screensService: any ScreenServiceProvider,
        keyboardVisualizerSettings: KeyboardVisualizerSettings
    ) -> Screen? {
        screensService.display(for: keyboardVisualizerSettings.screenID)
            ?? screensService.mainDisplay()
            ?? screensService.screens.first
    }

    func resolveSelectedScreen(for id: CGDirectDisplayID) -> Screen {
        self.screensService.display(for: id)
            ?? self.screensService.mainDisplay()
            ?? self.screens.first
            ?? self.selectedScreen
    }
}
