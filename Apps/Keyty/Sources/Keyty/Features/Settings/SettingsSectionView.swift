//
//  SettingsSectionView.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import SwiftUI

struct SettingsSectionView<Content: View>: View {
    let title: String?
    let subtitle: String?
    private let content: Content

    init(title: String? = nil, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            VStack(alignment: .leading) {
                if let title {
                    Text(title)
                        .font(Typography.Settings.sectionTitle)
                        .foregroundColor(Color.Theme.Text.header)
                        .padding(.leading, Spacing.grid(4))
                }
                
                if let subtitle {
                    Text(subtitle)
                        .font(Typography.Settings.sectionDescription)
                        .foregroundColor(Color.Theme.Text.secondary)
                        .padding(.leading, Spacing.grid(4))
                }
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                content
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg, style: .continuous)
                    .fill(Color.Theme.Surface.cardBackground)
            )
        }
    }
}
