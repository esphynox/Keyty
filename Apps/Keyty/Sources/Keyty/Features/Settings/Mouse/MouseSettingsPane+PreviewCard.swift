//
//  MouseSettingsPane+PreviewCard.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import SwiftUI

extension MouseSettingsPane {
    struct PreviewCard: View {
        private static let holdDuration: TimeInterval = 1.75
        private static let idleDuration: TimeInterval = 0.82

        @ObservedObject var model: MouseSettingsPaneViewModel
        @State private var ringPreviewAnimationID = UUID()
        @State private var ringPreviewAnimationState = PointerRingAnimation.VisualState.idle(alwaysVisible: false)
        @State private var iconPreviewAnimationID = UUID()
        @State private var iconPreviewVisualState = PointerIconContentView.VisualState.idle

        var body: some View {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: Radius.lg, style: .continuous)
                    .fill(Color.Theme.Surface.surfaceBackground)

                self.cursorPreview
            }
            .frame(height: Spacing.grid(40))
        }

        private var cursorPreview: some View {
            GeometryReader { geometry in
                ZStack {
                    self.selectedVisualizerPreview(in: geometry.size)
                    self.cursorImage
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .onAppear {
                self.updatePreviewAnimations()
            }
            .onDisappear {
                self.stopRingPreviewAnimation()
                self.stopIconPreviewAnimation()
            }
            .onChange(of: self.model.selectedSettingsTab) { _ in
                self.updatePreviewAnimations()
            }
            .onChange(of: self.model.ringAlwaysVisible) { alwaysVisible in
                guard self.model.selectedSettingsTab == .ring, self.ringPreviewAnimationState.scale == 1 else {
                    return
                }

                self.ringPreviewAnimationState = .idle(alwaysVisible: alwaysVisible)
            }
        }

        private var cursorImage: some View {
            let cursor = NSCursor.current
            let offset = self.cursorOffset(for: cursor)

            return Image(nsImage: cursor.image)
                .offset(x: offset.width, y: offset.height)
        }

        private func cursorOffset(for cursor: NSCursor) -> CGSize {
            let imageSize = cursor.image.size
            let hotspot = cursor.hotSpot

            return CGSize(
                width: imageSize.width / 2 - hotspot.x,
                height: imageSize.height / 2 - hotspot.y
            )
        }
    }
}

// MARK: - Visualizer Preview
private extension MouseSettingsPane.PreviewCard {
    @ViewBuilder
    func selectedVisualizerPreview(in size: CGSize) -> some View {
        switch self.model.selectedSettingsTab {
        case .ring:
            self.pointerRingPreview(in: size)
        case .icon:
            self.pointerIconPreview(in: size)
        }
    }
}

// MARK: - Ring Preview
private extension MouseSettingsPane.PreviewCard {
    func pointerRingPreview(in size: CGSize) -> some View {
        PointerRingPreviewShape(shape: self.model.ringShape)
            .stroke(
                Color(appKitColor: self.model.ringColor),
                style: StrokeStyle(
                    lineWidth: self.previewRingThickness,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .frame(
                width: self.previewRingSize(in: size),
                height: self.previewRingSize(in: size)
            )
            .scaleEffect(self.ringPreviewAnimationState.scale)
            .opacity(self.previewRingOpacity)
    }

    var previewRingOpacity: Double {
        self.model.ringAlwaysVisible
            ? PointerRingAnimation.visibleOpacity
            : self.ringPreviewAnimationState.opacity
    }

    func previewRingSize(in size: CGSize) -> CGFloat {
        let maximumSize = min(size.width, size.height) * 0.72
        return min(maximumSize, self.model.ringSize)
    }

    var previewRingThickness: CGFloat {
        let scale = self.previewScale(for: self.model.ringSize)
        return max(StrokeWidth.standard, self.model.ringThickness * scale)
    }

    func previewScale(for ringSize: CGFloat) -> CGFloat {
        guard ringSize > 0 else { return 1 }

        return min(1, Spacing.grid(40) * 0.72 / ringSize)
    }
}

// MARK: - Icon Preview
private extension MouseSettingsPane.PreviewCard {
    func pointerIconPreview(in size: CGSize) -> some View {
        let image = self.pointerIconPreviewImage
        let scale = self.previewIconScale(for: image.size, in: size)
        let offset = self.previewIconOffset(for: image.size, scale: scale)

        return Image(nsImage: image)
            .resizable()
            .frame(width: image.size.width * scale, height: image.size.height * scale)
            .offset(x: offset.width, y: offset.height)
            .opacity(self.previewIconOpacity)
    }

    var pointerIconPreviewImage: NSImage {
        PointerIconContentView.renderedImage(
            icon: self.iconPreviewVisualState.icon,
            displayedKind: self.iconPreviewVisualState.displayedKind,
            iconSize: self.model.iconSize,
            backgroundColor: self.model.iconBackgroundColor,
            tintColor: self.model.iconTintColor
        )
    }

    var previewIconOpacity: Double {
        self.model.iconAlwaysVisible || self.iconPreviewVisualState.isTransientlyVisible
            ? PointerRingAnimation.visibleOpacity
            : PointerRingAnimation.hiddenOpacity
    }

    func previewIconScale(for iconSize: NSSize, in containerSize: CGSize) -> CGFloat {
        let offset = CGFloat(self.model.iconOffset)
        let horizontalExtent = iconSize.width + offset
        let verticalExtent = iconSize.height + offset
        guard horizontalExtent > 0, verticalExtent > 0 else { return 1 }

        let availableWidth = containerSize.width * 0.42
        let availableHeight = containerSize.height * 0.42
        return min(1, availableWidth / horizontalExtent, availableHeight / verticalExtent)
    }

    func previewIconOffset(for iconSize: NSSize, scale: CGFloat) -> CGSize {
        let horizontalOffset = (iconSize.width / 2 + CGFloat(self.model.iconOffset)) * scale
        let verticalOffset = (iconSize.height / 2 + CGFloat(self.model.iconOffset)) * scale

        switch self.model.iconAnchorValue {
        case .bottomRight:
            return CGSize(width: horizontalOffset, height: verticalOffset)
        case .bottomLeft:
            return CGSize(width: -horizontalOffset, height: verticalOffset)
        case .topRight:
            return CGSize(width: horizontalOffset, height: -verticalOffset)
        case .topLeft:
            return CGSize(width: -horizontalOffset, height: -verticalOffset)
        }
    }
}

// MARK: - Preview Animation
private extension MouseSettingsPane.PreviewCard {
    func updatePreviewAnimations() {
        self.updateRingPreviewAnimation()
        self.updateIconPreviewAnimation()
    }

    func updateRingPreviewAnimation() {
        if self.model.selectedSettingsTab == .ring {
            self.startRingPreviewAnimation()
        } else {
            self.stopRingPreviewAnimation()
        }
    }

    func startRingPreviewAnimation() {
        let animationID = UUID()
        self.ringPreviewAnimationID = animationID
        self.ringPreviewAnimationState = .idle(alwaysVisible: self.model.ringAlwaysVisible)

        DispatchQueue.main.asyncAfter(deadline: .now() + Self.idleDuration / 2) {
            self.runRingPreviewAnimationCycle(animationID)
        }
    }

    func stopRingPreviewAnimation() {
        self.ringPreviewAnimationID = UUID()
        self.ringPreviewAnimationState = .idle(alwaysVisible: self.model.ringAlwaysVisible)
    }

    func runRingPreviewAnimationCycle(_ animationID: UUID) {
        guard self.canContinueRingPreviewAnimation(animationID) else {
            return
        }

        withAnimation(.easeOut(duration: PointerRingAnimation.pressAnimationDuration)) {
            self.ringPreviewAnimationState = .pressed
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Self.holdDuration) {
            guard self.canContinueRingPreviewAnimation(animationID) else {
                return
            }

            withAnimation(.easeOut(duration: PointerRingAnimation.releaseAnimationDuration)) {
                self.ringPreviewAnimationState = .released(alwaysVisible: self.model.ringAlwaysVisible)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + Self.idleDuration) {
                self.runRingPreviewAnimationCycle(animationID)
            }
        }
    }

    func canContinueRingPreviewAnimation(_ animationID: UUID) -> Bool {
        self.ringPreviewAnimationID == animationID && self.model.selectedSettingsTab == .ring
    }

    func updateIconPreviewAnimation() {
        if self.model.selectedSettingsTab == .icon {
            self.startIconPreviewAnimation()
        } else {
            self.stopIconPreviewAnimation()
        }
    }

    func startIconPreviewAnimation() {
        let animationID = UUID()
        self.iconPreviewAnimationID = animationID
        self.iconPreviewVisualState = .idle

        DispatchQueue.main.asyncAfter(deadline: .now() + Self.idleDuration / 2) {
            self.runIconPreviewAnimationCycle(animationID)
        }
    }

    func stopIconPreviewAnimation() {
        self.iconPreviewAnimationID = UUID()
        self.iconPreviewVisualState = .idle
    }

    func runIconPreviewAnimationCycle(_ animationID: UUID) {
        self.runIconPreviewEvent(at: 0, animationID: animationID)
    }

    func runIconPreviewEvent(at index: Int, animationID: UUID) {
        guard self.canContinueIconPreviewAnimation(animationID) else {
            return
        }

        guard index < PreviewIconEvent.allCases.count else {
            self.iconPreviewVisualState = .idle
            DispatchQueue.main.asyncAfter(deadline: .now() + Self.idleDuration) {
                self.runIconPreviewAnimationCycle(animationID)
            }
            return
        }

        let event = PreviewIconEvent.allCases[index]
        self.iconPreviewVisualState = event.visualState

        DispatchQueue.main.asyncAfter(deadline: .now() + event.duration) {
            guard self.canContinueIconPreviewAnimation(animationID) else {
                return
            }

            self.iconPreviewVisualState = .idle

            DispatchQueue.main.asyncAfter(deadline: .now() + Self.idleDuration) {
                self.runIconPreviewEvent(at: index + 1, animationID: animationID)
            }
        }
    }

    func canContinueIconPreviewAnimation(_ animationID: UUID) -> Bool {
        self.iconPreviewAnimationID == animationID && self.model.selectedSettingsTab == .icon
    }
}

// MARK: - Preview Types
private extension MouseSettingsPane.PreviewCard {
    private enum PreviewIconAnimation {
        static let clickDuration: TimeInterval = 1.2
        static let scrollDuration: TimeInterval = 1.0
    }

    private enum PreviewIconEvent: CaseIterable {
        case leftClick
        case rightClick
        case scrollUp
        case scrollDown

        var visualState: PointerIconContentView.VisualState {
            switch self {
            case .leftClick:
                return .leftClick
            case .rightClick:
                return .rightClick
            case .scrollUp:
                return .scrollUp
            case .scrollDown:
                return .scrollDown
            }
        }

        var duration: TimeInterval {
            switch self {
            case .leftClick, .rightClick:
                return PreviewIconAnimation.clickDuration
            case .scrollUp, .scrollDown:
                return PreviewIconAnimation.scrollDuration
            }
        }
    }
}

extension MouseSettingsPane.PreviewCard {
    private struct PointerRingPreviewShape: Shape {
        let shape: PointerRingShape

        func path(in rect: CGRect) -> Path {
            let path = PointerRingVisualizerWindow.makeVisualizerPath(
                shape: self.shape,
                rect: NSRect(origin: .zero, size: rect.size)
            )

            return Path(path.cgPath)
        }
    }
}
