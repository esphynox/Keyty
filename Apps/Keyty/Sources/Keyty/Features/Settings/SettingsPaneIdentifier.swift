//
//  SettingsPaneIdentifier.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import SwiftUI

enum SettingsPaneIdentifier: String, CaseIterable {
    case general
    case keyboard
    case mouse
    case displays
    case permissions
    case update
}

extension SettingsPaneIdentifier {
    var accessibilityIdentifier: String {
        "settings.sidebar.\(self.rawValue)"
    }

    var label: String {
        switch self {
        case .general:
            return L10n.Settings.Pane.general
        case .keyboard:
            return L10n.Settings.Pane.keyboard
        case .mouse:
            return L10n.Settings.Pane.mouse
        case .displays:
            return L10n.Settings.Pane.displays
        case .permissions:
            return L10n.Settings.Pane.permissions
        case .update:
            return L10n.Settings.Pane.update
        }
    }

    var sfSymbolName: String {
        switch self {
        case .general:
            return "gearshape.fill"
        case .keyboard:
            return "keyboard"
        case .mouse:
            return "computermouse"
        case .displays:
            return "display.2"
        case .permissions:
            return "hand.raised.fill"
        case .update:
            return "arrow.trianglehead.clockwise"
        }
    }

    var sidebarIconBaseColor: NSColor {
        switch self {
        case .general:
            return Color.Theme.Palette.graphite
        case .keyboard:
            return Color.Theme.Palette.blue
        case .mouse:
            return Color.Theme.Palette.orange
        case .displays:
            return Color.Theme.Palette.indigo
        case .permissions:
            return Color.Theme.Palette.red
        case .update:
            return Color.Theme.Palette.teal
        }
    }

    var sidebarIconGradient: LinearGradient {
        let baseColor = self.sidebarIconBaseColor

        return LinearGradient(
            colors: [
                Color(appKitColor: baseColor.lightened(by: 0.18)),
                Color(appKitColor: baseColor)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
