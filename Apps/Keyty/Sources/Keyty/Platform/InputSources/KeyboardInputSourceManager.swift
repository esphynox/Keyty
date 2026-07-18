//
//  KeyboardInputSourceManager.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Carbon
import Foundation

final class KeyboardInputSourceManager {
    static let shared = KeyboardInputSourceManager()

    private let inputSourceObserver: KeyboardInputSourceObserver
    private(set) var currentInputSource: TISInputSource

    init(
        inputSourceObserver: KeyboardInputSourceObserver = KeyboardInputSourceObserver(),
        currentInputSource: TISInputSource = TISCopyCurrentKeyboardLayoutInputSource().takeRetainedValue()
    ) {
        self.inputSourceObserver = inputSourceObserver
        self.currentInputSource = currentInputSource

        inputSourceObserver.inputSourceChanged = { [weak self] inputSource in
            self?.refreshCurrentInputSource(inputSource)
        }
    }

    private func refreshCurrentInputSource(_ inputSource: TISInputSource) {
        currentInputSource = inputSource
    }
}
