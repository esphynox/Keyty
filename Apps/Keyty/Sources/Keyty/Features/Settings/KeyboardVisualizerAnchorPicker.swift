//
//  KeyboardVisualizerAnchorPicker.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import SwiftUI

struct KeyboardVisualizerAnchorPicker: View {
    @Binding var selection: KeyboardVisualizerAnchor

    var body: some View {
        Picker("", selection: self.$selection) {
            ForEach(KeyboardVisualizerAnchor.allCases, id: \.self) { anchor in
                Text("\(anchor.symbol) \(anchor.label)").tag(anchor)
            }
        }
        .labelsHidden()
        .frame(width: Size.Control.settingsPickerWidth, alignment: .trailing)
    }
}
