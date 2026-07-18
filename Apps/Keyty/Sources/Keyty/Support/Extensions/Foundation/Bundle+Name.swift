//
//  Bundle+Name.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

extension Bundle {
    /// The user-facing app name from `CFBundleDisplayName`.
    var displayName: String? {
        self.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }

    /// The short app name from `CFBundleName`.
    var name: String? {
        self.object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}
