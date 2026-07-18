//
//  Typography.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import SwiftUI

enum Typography {
    enum Settings {
        static let windowTitle = Font.system(size: 30, weight: .semibold)
        static let paneTitle = Font.system(size: 16, weight: .semibold)
        static let sectionTitle = Font.system(size: 14, weight: .semibold)
        static let sectionDescription = Font.system(size: 11, weight: .regular)

        static let rowTitle = Font.system(size: 13, weight: .regular)
        static let rowSubtitle = Font.system(size: 11, weight: .regular)
        static let statusBadge = Font.system(size: 11, weight: .semibold)
        static let value = Font.system(size: 13, weight: .semibold)

        static let tileTitle = Font.system(size: 14, weight: .semibold)
        static let tileSubtitle = Font.system(size: 11, weight: .regular)
        static let tileSymbol = Font.system(size: 11, weight: .semibold)

        static let previewTitle = Font.system(size: 15, weight: .semibold)

        static let sidebarItem = Font.system(size: 13, weight: .regular)
        static let sidebarItemSymbol = Font.system(size: 13, weight: .semibold)
        static let sidebarBadge = Font.system(size: 10, weight: .bold)
        static let sidebarHeaderSymbol = Font.system(size: 18, weight: .black)
        static let sidebarAppName = Font.system(size: 22, weight: .semibold)
        static let sidebarSubtitle = Font.system(size: 12, weight: .medium)
    }
}
