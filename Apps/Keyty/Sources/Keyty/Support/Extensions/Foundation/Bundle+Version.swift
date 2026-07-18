//
//  Bundle+Version.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

extension Bundle {
    /// The user-facing app version from `CFBundleShortVersionString`.
    var appVersionString: String {
        self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0"
    }

    /// The internal build number from `CFBundleVersion`.
    var appBuildString: String {
        self.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
    }
}
