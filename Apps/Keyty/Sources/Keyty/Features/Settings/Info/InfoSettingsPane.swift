//
//  InfoSettingsPane.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import SwiftUI

struct InfoSettingsPane: View {
    var body: some View {
        SettingsStack {
            SettingsSectionView {
                SettingsLinkRow(
                    title: L10n.Info.githubLabel,
                    url: AppConstants.githubURL
                )

                Divider()

                SettingsLinkRow(
                    title: L10n.Info.websiteLabel,
                    url: AppConstants.websiteURL
                )

                Divider()

                SettingsLinkRow(
                    title: L10n.Info.emailLabel,
                    url: AppConstants.feedbackURL,
                    displayText: AppConstants.feedbackEmail
                )
            }

            HStack {
                Spacer(minLength: Spacing.none)

                Button(L10n.MainMenu.about(AppConstants.appName), action: self.showAbout)
                    .buttonStyle(.bordered)
                    .controlSize(.large)

                Spacer(minLength: Spacing.none)
            }
        }
    }

    private func showAbout() {
        NSApp.sendAction(#selector(AppController.orderFrontKeytyAboutPanel(_:)), to: nil, from: nil)
    }
}
