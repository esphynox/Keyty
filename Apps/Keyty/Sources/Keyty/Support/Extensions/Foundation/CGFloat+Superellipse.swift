//
//  CGFloat+Superellipse.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import CoreGraphics

public extension CGFloat {
    /// Maps a unit-circle component (`cos`/`sin` of an angle) onto a superellipse
    /// of the given `exponent`, preserving sign.
    ///
    /// Returns `signed(|self|^(2 / exponent))`. With `exponent == 2` this is the
    /// identity (a circle); larger exponents flatten the curve toward a squircle.
    func signedSuperellipseComponent(exponent: CGFloat) -> CGFloat {
        guard self != 0 else { return 0 }
        let magnitude = pow(abs(self), 2 / exponent)
        return self < 0 ? -magnitude : magnitude
    }
}
