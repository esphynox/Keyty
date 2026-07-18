//
//  GeneralSettingsPane.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import SwiftUI

struct GeneralSettingsPane: View {
    @StateObject private var model: GeneralSettingsPaneViewModel

    init(shortcutManager: ShortcutManager, presenceManager: PresenceManager, appSettings: any AppSettingsProtocol) {
        _model = StateObject(wrappedValue: GeneralSettingsPaneViewModel(
            shortcutManager: shortcutManager,
            presenceManager: presenceManager,
            appSettings: appSettings
        ))
    }

    var body: some View {
        SettingsStack {
            SettingsSectionView(title: L10n.General.appearanceSectionTitle) {
                SettingsControlRow(
                    title: L10n.General.displayIconLabel(AppConstants.appName),
                    subtitle: L10n.General.displayIconSubtitle
                ) {
                    Picker("", selection: $model.displayIconLocation) {
                        Text(L10n.General.DisplayIcon.menuBar).tag(DisplayIconLocation.menuBar.rawValue)
                        Text(L10n.General.DisplayIcon.dock).tag(DisplayIconLocation.dock.rawValue)
                        Text(L10n.General.DisplayIcon.menuBarAndDock).tag(DisplayIconLocation.menuBarAndDock.rawValue)
                    }
                    .labelsHidden()
                    .frame(width: Size.Control.settingsPickerWidth, alignment: .trailing)
                }
                
                Divider()
                
                SettingsControlRow(
                    title: L10n.General.showSettingsAtLaunch,
                    subtitle: L10n.General.showSettingsAtLaunchSubtitle
                ) {
                    Toggle("", isOn: $model.visibleAtLaunch)
                        .labelsHidden()
                        .toggleStyle(.switch)
                        .controlSize(.small)
                }
            }

            SettingsSectionView(title: L10n.General.shortcutSectionTitle) {
                SettingsControlRow(
                    title: L10n.General.toggleCapturingLabel,
                    subtitle: L10n.General.toggleCapturingSubtitle
                ) {
                    ShortcutRecorderView(shortcutManager: model.shortcutManager)
                        .frame(Size.Settings.recorder)
                }
            }
        }
    }
}
