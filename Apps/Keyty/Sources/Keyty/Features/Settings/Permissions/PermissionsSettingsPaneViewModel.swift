//
//  PermissionsSettingsPaneViewModel.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import SwiftUI

@MainActor
final class PermissionsSettingsPaneViewModel: ObservableObject {
    @Published private(set) var accessibilityStatus: Permission.Status

    private let permissionsService: any PermissionsService
    private var observationToken: PermissionObservationToken?

    init(permissionsService: any PermissionsService) {
        self.permissionsService = permissionsService
        self.accessibilityStatus = self.permissionsService.status(for: .accessibility)
        self.observationToken = self.permissionsService.observeChanges { [weak self] in
            Task { @MainActor [weak self] in
                self?.refresh()
            }
        }
    }

    func requestAccessibility() {
        self.handleAction(for: .accessibility)
        self.refresh()
    }

    func refresh() {
        self.accessibilityStatus = self.permissionsService.status(for: .accessibility)
    }

    private func handleAction(for permission: Permission) {
        guard self.permissionsService.status(for: permission) == .notGranted else { return }
        self.permissionsService.request(permission)
    }
}
