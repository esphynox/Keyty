//
//  SettingsSidebarView.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import SwiftUI

struct SettingsSidebarView: View {
    let entries: [SettingsPaneEntry]
    @ObservedObject var viewModel: SettingsSidebarViewModel
    
    private let panelCornerRadius: CGFloat = 16.0

    var body: some View {
        ZStack {
            VisualEffectView(material: .sidebar)
                .clipShape(RoundedRectangle(cornerRadius: self.panelCornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: self.panelCornerRadius, style: .continuous)
                        .stroke(Color.Theme.Settings.sidebarGlassOuterBorder, lineWidth: StrokeWidth.standard)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: self.panelCornerRadius, style: .continuous)
                        .inset(by: 1)
                        .stroke(Color.Theme.Settings.sidebarGlassInnerBorder, lineWidth: StrokeWidth.standard)
                )

            VStack(alignment: .leading, spacing: Spacing.md) {
                self.header
                    .padding(.horizontal, Spacing.xs)
                    .padding(.top, Spacing.xxl)

                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        ForEach(self.entries) { entry in
                            Button {
                                self.viewModel.select(entry.id)
                            } label: {
                                self.sidebarRow(for: entry)
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier(entry.id.accessibilityIdentifier)
                        }
                    }
                    .padding(.horizontal, Spacing.xs)
                    .padding(.bottom, Spacing.lg)
                }
            }
        }
        .frame(
            minWidth: Size.Settings.sidebarWidth,
            idealWidth: Size.Settings.sidebarWidth,
            maxWidth: Size.Settings.sidebarWidth,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .padding(Spacing.xs)
    }

    private func sidebarRow(for entry: SettingsPaneEntry) -> some View {
        HStack(spacing: Spacing.xxs) {
            self.iconBadge(for: entry)

            Text(entry.title)
                .font(Typography.Settings.sidebarItem)

            Spacer(minLength: 0)

            if let count = self.viewModel.badgeCount(for: entry.id) {
                self.countBadge(count)
            }
        }
        .foregroundColor(entry.id == self.viewModel.selectedPaneID ? Color.Theme.Text.sidebarItemSelected : Color.Theme.Text.sidebarItem)
        .padding(.horizontal, Spacing.xs)
        .padding(.vertical, Spacing.xxs)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(self.selectionBackground(isSelected: entry.id == self.viewModel.selectedPaneID))
        .contentShape(RoundedRectangle(cornerRadius: Radius.md, style: .continuous))
    }

    private func countBadge(_ count: Int) -> some View {
        Text(count > 99 ? "99+" : "\(count)")
            .font(Typography.Settings.sidebarBadge)
            .foregroundColor(Color.Theme.Brand.white)
            .lineLimit(1)
            .padding(.horizontal, Spacing.xxs)
            .frame(minWidth: Size.Settings.sidebarBadgeMinimumWidth, minHeight: Size.Settings.sidebarBadgeHeight)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.Theme.State.danger)
            )
    }

    private var logo: some View {
        Image(nsImage: NSApp.applicationIconImage)
            .resizable()
            .interpolation(.high)
            .scaledToFit()
            .frame(width: Spacing.grid(16), height: Spacing.grid(16))
    }

    private var header: some View {
        HStack(spacing: Spacing.xxs) {
            self.logo

            VStack(alignment: .leading, spacing: 0) {
                Text(AppConstants.appName)
                    .font(Typography.Settings.sidebarAppName)
                    .foregroundColor(Color.Theme.Text.primary)

                Text(L10n.Settings.sidebarVersion(
                    Bundle.main.appVersionString,
                    Bundle.main.appBuildString
                ))
                    .font(Typography.Settings.sidebarSubtitle)
                    .foregroundColor(Color.Theme.Text.secondary)
            }
        }
    }

    @ViewBuilder
    private func selectionBackground(isSelected: Bool) -> some View {
        if isSelected {
            RoundedRectangle(cornerRadius: Radius.md, style: .continuous)
                .fill(Color.Theme.Accent.controlAccent)
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.md, style: .continuous)
                        .stroke(Color.Theme.Border.selection, lineWidth: StrokeWidth.standard)
                )
        } else {
            RoundedRectangle(cornerRadius: Radius.md, style: .continuous)
                .fill(Color.Theme.Settings.clear)
        }
    }

    private func iconBadge(for entry: SettingsPaneEntry) -> some View {
        let isSelected = entry.id == self.viewModel.selectedPaneID

        return RoundedRectangle(cornerRadius: Radius.md, style: .continuous)
            .fill(entry.id.sidebarIconGradient)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md, style: .continuous)
                    .stroke(isSelected ? Color.Theme.Border.iconBadgeSelected : Color.Theme.Border.iconBadgeUnselected, lineWidth: StrokeWidth.standard)
            )
            .overlay(
                Image(systemName: entry.systemImageName)
                    .font(Typography.Settings.sidebarItemSymbol)
                    .foregroundColor(Color.Theme.Brand.white)
            )
            .frame(width: Spacing.grid(6), height: Spacing.grid(6))
            .shadow(color: isSelected ? Color.Theme.Shadow.iconBadgeSelected : Color.Theme.Shadow.iconBadgeUnselected, radius: isSelected ? 8 : 4, y: 2)
    }
}
