//
//  main.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

let app = NSApplication.shared
MainActor.assumeIsolated {
    let delegate = AppController()
    app.delegate = delegate
    app.run()
}
