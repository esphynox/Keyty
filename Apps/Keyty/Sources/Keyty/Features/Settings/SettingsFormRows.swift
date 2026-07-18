//
//  SettingsFormRows.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import SwiftUI

struct SettingsStack<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            content
        }
    }
}

struct SettingsControlRow<Content: View>: View {
    let title: String
    let subtitle: String?
    private let content: Content

    init(title: String, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        HStack(alignment: .center, spacing: Spacing.md) {
            VStack(alignment: .leading, spacing: Spacing.none) {
                Text(self.title)
                    .font(Typography.Settings.rowTitle)
                    .foregroundColor(Color.Theme.Text.primary)

                if let subtitle {
                    Text(subtitle)
                        .font(Typography.Settings.rowSubtitle)
                        .foregroundColor(Color.Theme.Text.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            self.content
                .frame(minWidth: Size.Control.settingsPickerWidth, alignment: .trailing)
        }
        .padding(.vertical, Spacing.none)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct SettingsSliderEdgeLabels {
    let leading: String
    let trailing: String
}

struct SettingsSliderControl: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double?
    let width: CGFloat
    let edgeLabels: SettingsSliderEdgeLabels?

    init(
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double? = nil,
        width: CGFloat = Spacing.grid(44),
        edgeLabels: SettingsSliderEdgeLabels? = nil
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.width = width
        self.edgeLabels = edgeLabels
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxs) {
            Group {
                if let step = self.step {
                    Slider(value: self.$value, in: self.range, step: step)
                } else {
                    Slider(value: self.$value, in: self.range)
                }
            }
            .frame(width: self.width)

            if let edgeLabels = self.edgeLabels {
                HStack(spacing: Spacing.none) {
                    Text(edgeLabels.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(edgeLabels.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .font(Typography.Settings.rowSubtitle)
                .foregroundColor(Color.Theme.Text.secondary)
                .frame(width: self.width)
            }
        }
    }
}
