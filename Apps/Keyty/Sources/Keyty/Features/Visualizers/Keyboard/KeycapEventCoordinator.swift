//
//  KeycapEventCoordinator.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

protocol KeycapGroupItem {
    var identity: KeycapIdentity { get }
}

final class KeycapEventCoordinator<GroupView: AnyObject, Item: KeycapGroupItem> {
    private var pendingModifierGroup: GroupView?
    private var completedModifierGroup: GroupView?
    private var activeKeyGroups: [UInt16: GroupView] = [:]
    private var activeMouseGroups: [MouseEvent.Kind: GroupView] = [:]
    private var groupItems: [ObjectIdentifier: [Item]] = [:]

    func reset() {
        pendingModifierGroup = nil
        completedModifierGroup = nil
        activeKeyGroups.removeAll(keepingCapacity: true)
        activeMouseGroups.removeAll(keepingCapacity: true)
        groupItems.removeAll(keepingCapacity: true)
    }

    func handleFlagsChanged(
        currentTrackedFlags: NSEvent.ModifierFlags,
        releasedTrackedFlags: NSEvent.ModifierFlags,
        buildItems: (NSEvent.ModifierFlags, NSEvent.ModifierFlags) -> [Item],
        appendGroup: ([Item]) -> GroupView,
        updateGroup: (GroupView, [Item]) -> Void
    ) {
        let items = buildItems(currentTrackedFlags, releasedTrackedFlags)
        guard !items.isEmpty else {
            if currentTrackedFlags.isEmpty {
                pendingModifierGroup = nil
                completedModifierGroup = nil
            }
            return
        }

        if let pendingModifierGroup, canAppendModifiers(to: pendingModifierGroup) {
            let merged = ordered(items: merged(items: items, into: storedItems(for: pendingModifierGroup)))
            groupItems[ObjectIdentifier(pendingModifierGroup)] = merged
            updateGroup(pendingModifierGroup, merged)
            completedModifierGroup = pendingModifierGroup
        } else if let completedModifierGroup, canRefreshModifiers(in: completedModifierGroup, with: items) {
            let merged = ordered(items: merged(items: items, into: storedItems(for: completedModifierGroup)))
            groupItems[ObjectIdentifier(completedModifierGroup)] = merged
            updateGroup(completedModifierGroup, merged)
        } else {
            let orderedItems = ordered(items: items)
            let group = appendGroup(orderedItems)
            groupItems[ObjectIdentifier(group)] = orderedItems
            pendingModifierGroup = group
            completedModifierGroup = group
        }

        if currentTrackedFlags.isEmpty {
            pendingModifierGroup = nil
            completedModifierGroup = nil
        }
    }

    func handleTrackedKey(
        keyCode: UInt16,
        isKeyDown: Bool,
        items: [Item],
        appendGroup: ([Item]) -> GroupView,
        updateGroup: (GroupView, [Item]) -> Void
    ) {
        guard !items.isEmpty else { return }

        if let activeGroup = activeKeyGroups[keyCode] {
            let existingItems = storedItems(for: activeGroup)
            let permittedItems = permittedTrackedKeyItems(items, forExistingItems: existingItems)
            let merged = ordered(items: merged(items: permittedItems, into: existingItems))
            groupItems[ObjectIdentifier(activeGroup)] = merged
            updateGroup(activeGroup, merged)
            pendingModifierGroup = activeGroup
            completedModifierGroup = activeGroup
            if !isKeyDown {
                activeKeyGroups[keyCode] = nil
            }
            return
        }

        if let pendingModifierGroup, canAbsorbIntoPendingChord(pendingModifierGroup) {
            let merged = ordered(items: merged(items: items, into: storedItems(for: pendingModifierGroup)))
            groupItems[ObjectIdentifier(pendingModifierGroup)] = merged
            updateGroup(pendingModifierGroup, merged)
            self.pendingModifierGroup = pendingModifierGroup
            completedModifierGroup = pendingModifierGroup
            activeKeyGroups[keyCode] = pendingModifierGroup
            if !isKeyDown {
                activeKeyGroups[keyCode] = nil
            }
            return
        }

        let orderedItems = ordered(items: items)
        let group = appendGroup(orderedItems)
        groupItems[ObjectIdentifier(group)] = orderedItems
        pendingModifierGroup = group
        completedModifierGroup = group
        if isKeyDown {
            activeKeyGroups[keyCode] = group
        }
    }

    func handleMouseButton(
        kind: MouseEvent.Kind,
        isPressed: Bool,
        items: [Item],
        appendGroup: ([Item]) -> GroupView,
        updateGroup: (GroupView, [Item]) -> Void
    ) {
        guard !items.isEmpty else { return }

        if let activeGroup = activeMouseGroups[kind] {
            let merged = ordered(items: merged(items: items, into: storedItems(for: activeGroup)))
            groupItems[ObjectIdentifier(activeGroup)] = merged
            updateGroup(activeGroup, merged)
            pendingModifierGroup = activeGroup
            completedModifierGroup = activeGroup
            if !isPressed {
                activeMouseGroups[kind] = nil
            }
            return
        }

        if let pendingModifierGroup, canAbsorbIntoPendingChord(pendingModifierGroup) {
            let merged = ordered(items: merged(items: items, into: storedItems(for: pendingModifierGroup)))
            groupItems[ObjectIdentifier(pendingModifierGroup)] = merged
            updateGroup(pendingModifierGroup, merged)
            completedModifierGroup = pendingModifierGroup
            if isPressed {
                activeMouseGroups[kind] = pendingModifierGroup
            }
            return
        }

        let orderedItems = ordered(items: items)
        let group = appendGroup(orderedItems)
        groupItems[ObjectIdentifier(group)] = orderedItems
        completedModifierGroup = group
        if isPressed {
            activeMouseGroups[kind] = group
        }
    }

    func handleStandalone(
        items: [Item],
        appendGroup: ([Item]) -> GroupView,
        updateGroup: (GroupView, [Item]) -> Void
    ) {
        guard !items.isEmpty else { return }

        if let pendingModifierGroup, canAbsorbIntoPendingChord(pendingModifierGroup) {
            let merged = ordered(items: merged(items: items, into: storedItems(for: pendingModifierGroup)))
            groupItems[ObjectIdentifier(pendingModifierGroup)] = merged
            updateGroup(pendingModifierGroup, merged)
            completedModifierGroup = pendingModifierGroup
            return
        }

        let group = appendGroup(items)
        groupItems[ObjectIdentifier(group)] = items
    }

    private func storedItems(for group: GroupView) -> [Item] {
        groupItems[ObjectIdentifier(group)] ?? []
    }

    /// Only pure modifier previews can absorb later modifier-only updates.
    private func canAppendModifiers(to group: GroupView) -> Bool {
        let items = storedItems(for: group)
        return !items.isEmpty && items.allSatisfy(\.identity.isModifier)
    }

    /// Only a pure modifier preview can absorb the first non-modifier key in a chord.
    private func canAbsorbIntoPendingChord(_ group: GroupView) -> Bool {
        canAppendModifiers(to: group)
    }

    /// Existing chord groups may only receive modifier updates for modifiers they already show.
    private func canRefreshModifiers(in group: GroupView, with items: [Item]) -> Bool {
        let existingModifierIdentities = Set(
            storedItems(for: group)
                .filter { $0.identity.isModifier }
                .map(\.identity)
        )
        let incomingModifierIdentities = Set(
            items
                .filter { $0.identity.isModifier }
                .map(\.identity)
        )
        return !incomingModifierIdentities.isEmpty && incomingModifierIdentities.isSubset(of: existingModifierIdentities)
    }

    /// Tracked key updates may refresh existing modifiers, but cannot introduce new ones.
    private func permittedTrackedKeyItems(_ newItems: [Item], forExistingItems existingItems: [Item]) -> [Item] {
        let existingModifierIdentities = Set(
            existingItems
                .filter { $0.identity.isModifier }
                .map(\.identity)
        )

        return newItems.filter { item in
            !item.identity.isModifier || existingModifierIdentities.contains(item.identity)
        }
    }

    private func merged(items newItems: [Item], into existingItems: [Item]) -> [Item] {
        guard !existingItems.isEmpty else { return newItems }

        var merged = existingItems
        for item in newItems {
            if let index = merged.firstIndex(where: { $0.identity == item.identity }) {
                merged[index] = item
            } else {
                merged.append(item)
            }
        }
        return merged
    }

    private func ordered(items: [Item]) -> [Item] {
        let modifiers = items.filter { $0.identity.isModifier }
        let others = items.filter { !$0.identity.isModifier }
        return modifiers + others
    }
}
