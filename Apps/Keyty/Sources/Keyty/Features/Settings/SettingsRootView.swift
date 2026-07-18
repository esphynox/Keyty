//
//  SettingsRootView.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import SwiftUI

struct SettingsRootView: View {
    let registry: SettingsPaneRegistry
    @ObservedObject var sidebarViewModel: SettingsSidebarViewModel

    var body: some View {
        HStack(spacing: Spacing.none) {
            SettingsSidebarView(entries: registry.entries, viewModel: sidebarViewModel)

            Divider()
                .overlay(Color.Theme.Border.sidebar)

            Group {
                if let selectedEntry = registry.entry(for: sidebarViewModel.selectedPaneID) {
                    SettingsDetailContainer(title: selectedEntry.title) {
                        selectedEntry.makeView()
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                } else {
                    SettingsDetailContainer(title: AppConstants.appName) {
                        EmptyView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .ignoresSafeArea(edges: .top)
        .frame(
            minWidth: Size.Window.settings.width,
            minHeight: Size.Window.settings.height
        )
    }
}
