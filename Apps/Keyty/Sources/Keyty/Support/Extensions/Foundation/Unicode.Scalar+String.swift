//
//  Unicode.Scalar+String.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

extension Unicode.Scalar {
    /// Wraps the scalar in a single-scalar `String`.
    var string: String { String(self) }
}
