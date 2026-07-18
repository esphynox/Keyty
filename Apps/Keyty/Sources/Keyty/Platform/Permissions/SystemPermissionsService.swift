//
//  SystemPermissionsService.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

protocol PermissionsProvider {
    func isGranted(_ permission: Permission) -> Bool
    func request(_ permission: Permission)
}

private struct LivePermissionsProvider: PermissionsProvider {
    func isGranted(_ permission: Permission) -> Bool {
        permission.isGranted()
    }

    func request(_ permission: Permission) {
        permission.requestSystemPermission()
    }
}

final class SystemPermissionsService {
    private let provider: any PermissionsProvider
    private var observers: [UUID: () -> Void] = [:]
    private var lastStatuses: [Permission: Permission.Status] = [:]
    private var pollTimer: Timer?

    init(provider: any PermissionsProvider = LivePermissionsProvider()) {
        self.provider = provider
    }
}

// MARK: - PermissionsService
extension SystemPermissionsService: PermissionsService {
    func status(for permission: Permission) -> Permission.Status {
        self.provider.isGranted(permission) ? .granted : .notGranted
    }

    func request(_ permission: Permission) {
        guard self.status(for: permission) == .notGranted else { return }
        self.provider.request(permission)
    }

    func observeChanges(handler: @escaping () -> Void) -> PermissionObservationToken {
        let id = UUID()
        self.observers[id] = handler
        self.startPollingIfNeeded()
        return PermissionObservationToken { [weak self] in
            self?.observers.removeValue(forKey: id)
            if self?.observers.isEmpty == true { self?.stopPolling() }
        }
    }
}

private extension SystemPermissionsService {
    private func checkForChanges() {
        let currentStatuses = currentStatuses()
        guard currentStatuses != lastStatuses else {
            return
        }
        self.lastStatuses = currentStatuses
        self.observers.values.forEach { $0() }
    }

    private func currentStatuses() -> [Permission: Permission.Status] {
        Permission.allCases.reduce(into: [:]) { statuses, permission in
            statuses[permission] = self.status(for: permission)
        }
    }
}

// MARK: - Polling
private extension SystemPermissionsService {
    func startPollingIfNeeded() {
        guard self.pollTimer == nil else { return }
        lastStatuses = self.currentStatuses()
        self.pollTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.checkForChanges()
        }
    }

    func stopPolling() {
        self.pollTimer?.invalidate()
        self.pollTimer = nil
    }
}
