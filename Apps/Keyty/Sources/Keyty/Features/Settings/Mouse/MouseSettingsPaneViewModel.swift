//
//  MouseSettingsPaneViewModel.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import SwiftUI

@MainActor
final class MouseSettingsPaneViewModel: ObservableObject {
    static let customRingColorSelectionID = "__custom_ring_color__"
    static let customIconBackgroundColorSelectionID = "__custom_icon_background_color__"
    static let customIconTintColorSelectionID = "__custom_icon_tint_color__"

    static let ringSizeRange: ClosedRange<Double> =
        Double(PointerRingSettingsKeys.sizeRange.lowerBound)...Double(PointerRingSettingsKeys.sizeRange.upperBound)
    static let ringSizeStep: Double = 4

    static let ringThicknessRange: ClosedRange<Double> =
        Double(PointerRingSettingsKeys.thicknessRange.lowerBound)...Double(PointerRingSettingsKeys.thicknessRange.upperBound)
    static let ringThicknessStep: Double = 1

    private let ringVisualizer: PointerRingVisualizer
    private let ringSettings: any PointerRingSettingsProtocol
    private let iconSettings: any PointerIconSettingsProtocol
    private var ringColorSelectionOverride: String?
    private var iconBackgroundColorSelectionOverride: String?
    private var iconTintColorSelectionOverride: String?

    @Published var selectedSettingsTab = SettingsTab.ring

    @Published var ringEnabled: Bool {
        didSet { self.ringVisualizer.isEnabled = self.ringEnabled }
    }

    @Published var ringColor: NSColor {
        didSet { self.ringSettings.color = self.ringColor }
    }

    @Published var ringAlwaysVisible: Bool {
        didSet { self.ringSettings.alwaysVisible = self.ringAlwaysVisible }
    }

    @Published var ringSize: Double {
        didSet {
            let clamped = min(max(self.ringSize, Self.ringSizeRange.lowerBound), Self.ringSizeRange.upperBound)
            self.ringSettings.size = CGFloat(clamped)
        }
    }

    @Published var ringThickness: Double {
        didSet {
            let clamped = min(max(self.ringThickness, Self.ringThicknessRange.lowerBound), Self.ringThicknessRange.upperBound)
            self.ringSettings.thickness = CGFloat(clamped)
        }
    }

    @Published var ringShape: PointerRingShape {
        didSet { self.ringSettings.shape = self.ringShape }
    }

    @Published var iconEnabled: Bool {
        didSet { self.iconSettings.isEnabled = self.iconEnabled }
    }

    @Published var iconAlwaysVisible: Bool {
        didSet { self.iconSettings.alwaysVisible = self.iconAlwaysVisible }
    }

    @Published var iconAnchor: Int {
        didSet {
            if let anchor = PointerIconAnchor(rawValue: self.iconAnchor) {
                self.iconSettings.anchor = anchor
            }
        }
    }

    @Published var iconOffset: Double {
        didSet { self.iconSettings.offset = CGFloat(self.iconOffset) }
    }

    @Published var iconSizeIndex: Double {
        didSet { self.iconSettings.sizeIndex = Int(self.iconSizeIndex.rounded()) }
    }

    @Published var iconBackgroundColor: NSColor {
        didSet { self.iconSettings.backgroundColor = self.iconBackgroundColor }
    }

    @Published var iconTintColor: NSColor {
        didSet { self.iconSettings.tintColor = self.iconTintColor }
    }

    init(
        ringVisualizer: PointerRingVisualizer,
        ringSettings: any PointerRingSettingsProtocol,
        iconSettings: any PointerIconSettingsProtocol
    ) {
        self.ringVisualizer = ringVisualizer
        self.ringSettings = ringSettings
        self.iconSettings = iconSettings

        self.ringEnabled = ringVisualizer.isEnabled
        self.ringColor = ringSettings.color
        self.ringAlwaysVisible = ringSettings.alwaysVisible
        self.ringSize = Double(ringSettings.size)
        self.ringThickness = Double(ringSettings.thickness)
        self.ringShape = ringSettings.shape

        self.iconEnabled = iconSettings.isEnabled
        self.iconAlwaysVisible = iconSettings.alwaysVisible
        self.iconAnchor = iconSettings.anchor.rawValue
        self.iconOffset = Double(iconSettings.offset)
        self.iconSizeIndex = Double(iconSettings.sizeIndex)
        self.iconBackgroundColor = iconSettings.backgroundColor
        self.iconTintColor = iconSettings.tintColor
    }


    var ringColorTitle: String {
        let selectedHex = self.ringColor.hexString
        return MouseSettingsPaneViewModel.ColorPreset.ringColorPresets.first { $0.color.hexString == selectedHex }?.title
            ?? L10n.Mouse.chooseColor
    }

    var ringColorSelectionID: String {
        if let override = self.ringColorSelectionOverride {
            return override
        }

        return MouseSettingsPaneViewModel.ColorPreset.ringColorPresets.first { $0.color.hexString == self.ringColor.hexString }?.color.hexString
            ?? Self.customRingColorSelectionID
    }

    var iconBackgroundColorSelectionID: String {
        self.selectionID(
            for: self.iconBackgroundColor,
            sections: MouseSettingsPaneViewModel.ColorPreset.iconBackgroundColorSections,
            selectionOverride: self.iconBackgroundColorSelectionOverride,
            customSelectionID: Self.customIconBackgroundColorSelectionID
        )
    }

    var iconTintColorSelectionID: String {
        self.selectionID(
            for: self.iconTintColor,
            sections: MouseSettingsPaneViewModel.ColorPreset.iconTintColorSections,
            selectionOverride: self.iconTintColorSelectionOverride,
            customSelectionID: Self.customIconTintColorSelectionID
        )
    }

    var iconAnchorValue: PointerIconAnchor {
        PointerIconAnchor(rawValue: self.iconAnchor) ?? PointerIconSettingsKeys.defaultAnchor
    }

    var iconSize: NSSize {
        let index = Int(self.iconSizeIndex.rounded())
        let clamped = min(max(0, index), PointerIconSettingsKeys.iconSizes.count - 1)
        return PointerIconSettingsKeys.iconSizes[clamped]
    }

    func selectRingColor(with selectionID: String) {
        guard let preset = MouseSettingsPaneViewModel.ColorPreset.ringColorPresets.first(where: { $0.color.hexString == selectionID }) else {
            return
        }

        self.ringColorSelectionOverride = nil
        self.ringColor = preset.color
    }

    func beginChoosingCustomRingColor() {
        self.ringColorSelectionOverride = Self.customRingColorSelectionID
    }

    func applyCustomRingColor(_ color: NSColor) {
        self.ringColor = color
        self.ringColorSelectionOverride = Self.customRingColorSelectionID
    }

    func selectIconBackgroundColor(with selectionID: String) {
        self.selectIconColor(
            with: selectionID,
            sections: MouseSettingsPaneViewModel.ColorPreset.iconBackgroundColorSections,
            selectionOverride: &self.iconBackgroundColorSelectionOverride,
            applyColor: { self.iconBackgroundColor = $0 }
        )
    }

    func beginChoosingCustomIconBackgroundColor() {
        self.iconBackgroundColorSelectionOverride = Self.customIconBackgroundColorSelectionID
    }

    func applyCustomIconBackgroundColor(_ color: NSColor) {
        self.iconBackgroundColor = color
        self.iconBackgroundColorSelectionOverride = Self.customIconBackgroundColorSelectionID
    }

    func selectIconTintColor(with selectionID: String) {
        self.selectIconColor(
            with: selectionID,
            sections: MouseSettingsPaneViewModel.ColorPreset.iconTintColorSections,
            selectionOverride: &self.iconTintColorSelectionOverride,
            applyColor: { self.iconTintColor = $0 }
        )
    }

    func beginChoosingCustomIconTintColor() {
        self.iconTintColorSelectionOverride = Self.customIconTintColorSelectionID
    }

    func applyCustomIconTintColor(_ color: NSColor) {
        self.iconTintColor = color
        self.iconTintColorSelectionOverride = Self.customIconTintColorSelectionID
    }

    private func selectionID(
        for color: NSColor,
        sections: [[ColorPreset]],
        selectionOverride: String?,
        customSelectionID: String
    ) -> String {
        if let selectionOverride {
            return selectionOverride
        }

        return sections
            .joined()
            .first { $0.color.hexString == color.hexString }?
            .color.hexString
            ?? customSelectionID
    }

    private func selectIconColor(
        with selectionID: String,
        sections: [[ColorPreset]],
        selectionOverride: inout String?,
        applyColor: (NSColor) -> Void
    ) {
        guard let preset = sections
            .joined()
            .first(where: { $0.color.hexString == selectionID }) else {
            return
        }

        selectionOverride = nil
        applyColor(preset.color)
    }
}

extension MouseSettingsPaneViewModel {
    enum SettingsTab: CaseIterable {
        case ring
        case icon

        var title: String {
            switch self {
            case .ring:
                return L10n.Mouse.tabRing
            case .icon:
                return L10n.Mouse.tabIcon
            }
        }
    }
}
