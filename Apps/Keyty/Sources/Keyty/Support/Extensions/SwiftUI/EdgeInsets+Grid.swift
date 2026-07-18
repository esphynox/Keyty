//
//  EdgeInsets+Grid.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import SwiftUI

extension EdgeInsets {
    init(_ spacing: CGFloat) {
        self.init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
    }
}
