//
//  KeycapLayoutHints.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

/// Rendering hints that affect layout but do not change semantic meaning.
struct KeycapLayoutHints {
    let alignment: KeycapLegendAlignment
    let fixedWidth: CGFloat?

    init(
        alignment: KeycapLegendAlignment = .automatic,
        fixedWidth: CGFloat? = nil
    ) {
        self.alignment = alignment
        self.fixedWidth = fixedWidth
    }
}
