//
//  GlobalShortcutMonitoring.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import ShortcutRecorder

/// Registers and removes app-level global shortcut actions.
protocol GlobalShortcutMonitoring: AnyObject {
    /// Registers an action for the key event represented by a validated shortcut.
    func addAction(_ action: ShortcutAction, forKeyEvent keyEvent: KeyEventType)

    /// Removes a previously registered action from the global shortcut monitor.
    func removeAction(_ action: ShortcutAction)
}

extension GlobalShortcutMonitor: GlobalShortcutMonitoring {}
