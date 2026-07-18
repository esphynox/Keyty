//
//  KeyboardVisualizerAnchor.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

struct KeyboardVisualizerAnchor: Hashable {
    var horizontal: Horizontal
    var vertical: Vertical

    var label: String {
        "\(vertical.label) \(horizontal.label)"
    }

    var symbol: String {
        switch (self.vertical, self.horizontal) {
        case (.top, .leading):      UnicodeToken.upLeftArrow.string
        case (.top, .center):       UnicodeToken.upArrow.string
        case (.top, .trailing):     UnicodeToken.upRightArrow.string
        case (.middle, .leading):   UnicodeToken.leftArrow.string
        case (.middle, .trailing):  UnicodeToken.rightArrow.string
        case (.bottom, .leading):   UnicodeToken.downLeftArrow.string
        case (.bottom, .center):    UnicodeToken.downArrow.string
        case (.bottom, .trailing):  UnicodeToken.downRightArrow.string
        case (.middle, .center):    UnicodeToken.bulletOperator.string
        }
    }
}

extension KeyboardVisualizerAnchor {
    enum Horizontal: Int, CaseIterable {
        case leading
        case center
        case trailing

        var label: String {
            switch self {
            case .leading:  L10n.Anchor.left
            case .center:   L10n.Anchor.center
            case .trailing: L10n.Anchor.right
            }
        }
    }

    enum Vertical: Int, CaseIterable {
        case top
        case middle
        case bottom

        var label: String {
            switch self {
            case .top:    L10n.Anchor.top
            case .middle: L10n.Anchor.verticalCenter
            case .bottom: L10n.Anchor.bottom
            }
        }
    }

}

// MARK: - RawRepresentable
extension KeyboardVisualizerAnchor: RawRepresentable {
    // Persisted as a single Int (`vertical * 3 + horizontal`), preserving the original
    // 0...8 ordering (topLeft = 0 ... bottomRight = 8).
    init?(rawValue: Int) {
        guard let vertical = Vertical(rawValue: rawValue / 3),
              let horizontal = Horizontal(rawValue: rawValue % 3) else {
            return nil
        }
        self.init(horizontal: horizontal, vertical: vertical)
    }

    var rawValue: Int {
        vertical.rawValue * 3 + horizontal.rawValue
    }
}

// MARK: - CaseIterable
extension KeyboardVisualizerAnchor: CaseIterable {
    static let allCases: [KeyboardVisualizerAnchor] = [
        .topLeft,
        .topCenter,
        .topRight,
        .middleLeft,
        .middleRight,
        .bottomLeft,
        .bottomCenter,
        .bottomRight,
    ]
}

// MARK: - Instances
extension KeyboardVisualizerAnchor {
    static let topLeft      = KeyboardVisualizerAnchor(horizontal: .leading,  vertical: .top)
    static let topCenter    = KeyboardVisualizerAnchor(horizontal: .center,   vertical: .top)
    static let topRight     = KeyboardVisualizerAnchor(horizontal: .trailing, vertical: .top)
    static let middleLeft   = KeyboardVisualizerAnchor(horizontal: .leading,  vertical: .middle)
    static let middleRight  = KeyboardVisualizerAnchor(horizontal: .trailing, vertical: .middle)
    static let bottomLeft   = KeyboardVisualizerAnchor(horizontal: .leading,  vertical: .bottom)
    static let bottomCenter = KeyboardVisualizerAnchor(horizontal: .center,   vertical: .bottom)
    static let bottomRight  = KeyboardVisualizerAnchor(horizontal: .trailing, vertical: .bottom)
    
    static let `default` = Self.bottomCenter
}
