//
//  AboutWindowView.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import SwiftUI

struct AboutWindowView: View {
    @ObservedObject var viewModel: AboutWindowViewModel

    var body: some View {
        HStack(spacing: Spacing.none) {
            self.sidebar
            self.detail
        }
        .padding(Spacing.grid(2))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg + Spacing.unit, style: .continuous)
                .stroke(Color.Theme.Border.primary, lineWidth: StrokeWidth.standard)
        )
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg + Spacing.unit, style: .continuous))
        .ignoresSafeArea(edges: .top)
        .frame(width: Size.Window.about.width, height: Size.Window.about.height)
    }

    private var sidebar: some View {
        ZStack {
            VisualEffectView(material: .sidebar)
                .clipShape(RoundedRectangle(cornerRadius: Radius.lg + Spacing.unit, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.lg + Spacing.unit, style: .continuous)
                        .stroke(Color.Theme.Settings.sidebarGlassOuterBorder, lineWidth: StrokeWidth.standard)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.lg + Spacing.unit, style: .continuous)
                        .inset(by: 1)
                        .stroke(Color.Theme.Settings.sidebarGlassInnerBorder, lineWidth: StrokeWidth.standard)
                )

            VStack(spacing: Spacing.none) {
                Spacer(minLength: Spacing.grid(7))

                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Spacing.grid(18), height: Spacing.grid(18))
                    .clipShape(RoundedRectangle(cornerRadius: Radius.lg, style: .continuous))
                    .shadow(color: Color.Theme.Shadow.iconBadgeSelected, radius: 12, y: 4)

                VStack(spacing: Spacing.xs) {
                    Text(self.viewModel.appName)
                        .font(.system(size: 21, weight: .light))
                        .foregroundColor(Color.Theme.Text.primary)

                    Text(self.viewModel.versionString)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.Theme.Text.secondary)
                }
                .padding(.top, Spacing.md)

                Spacer()

                VStack(spacing: Spacing.sm) {
                    ForEach(AboutWindowViewModel.Tab.allCases) { tab in
                        Button {
                            self.viewModel.selectedTab = tab
                        } label: {
                            Text(tab.title)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(self.viewModel.selectedTab == tab ? Color.Theme.Text.sidebarItemSelected : Color.Theme.Text.sidebarItem)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Spacing.xs)
                                .contentShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .background(self.tabBackground(for: tab))
                    }
                }
                .padding(.horizontal, Spacing.grid(3))
                .padding(.bottom, Spacing.grid(3))
            }
        }
        .frame(width: Spacing.grid(50))
        .frame(maxHeight: .infinity)
    }

    private var detail: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: Spacing.grid(7)) {
                ForEach(self.viewModel.selectedSections) { section in
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text(section.title)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color.Theme.Text.primary)

                        if !section.subtitle.isEmpty {
                            Text(section.subtitle)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(Color.Theme.Text.secondary)
                        }

                        if !section.links.isEmpty {
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                ForEach(section.links) { link in
                                    HStack(spacing: Spacing.xs) {
                                        Text("\(link.title):")
                                            .font(.system(size: 11, weight: .medium, design: .rounded))
                                            .foregroundColor(Color.Theme.Text.secondary)

                                        Link(destination: link.url) {
                                            Text(link.url.absoluteString)
                                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                                .foregroundColor(Color.Theme.About.linkText)
                                                .underline()
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }

                        if !section.listItems.isEmpty {
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                ForEach(section.listItems) { item in
                                    VStack(alignment: .leading, spacing: Spacing.xs) {
                                        Text(item.title)
                                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                                            .foregroundColor(Color.Theme.Text.primary)

                                        if !item.subtitle.isEmpty {
                                            Text(item.subtitle)
                                                .font(.system(size: 11, weight: .regular, design: .rounded))
                                                .foregroundColor(Color.Theme.Text.secondary)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                }
                            }
                        }

                        if !section.body.isEmpty {
                            Self.AboutBodyText(text: section.body)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.grid(4))
            .padding(.vertical, Spacing.grid(4))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Theme.Surface.detailBackground)
    }

    @ViewBuilder
    private func tabBackground(for tab: AboutWindowViewModel.Tab) -> some View {
        if self.viewModel.selectedTab == tab {
            Capsule()
                .fill(Color.Theme.Accent.controlAccent)
                .overlay(
                    Capsule()
                        .stroke(Color.Theme.Border.selection, lineWidth: StrokeWidth.standard)
                )
        } else {
            Capsule()
                .fill(Color.clear)
        }
    }
}

private extension AboutWindowView {
    struct AboutBodyText: View {
        let text: String

        var body: some View {
            LazyVStack(alignment: .leading, spacing: Spacing.none) {
                ForEach(Array(self.text.components(separatedBy: .newlines).enumerated()), id: \.offset) { _, line in
                    if line.isEmpty {
                        Spacer()
                            .frame(height: Spacing.xs)
                    } else {
                        Text(line)
                            .font(.system(size: 11, weight: .regular, design: .rounded))
                            .foregroundColor(Color.Theme.Text.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }
}
