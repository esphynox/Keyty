//
//  InputEventGlyphMapper.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

enum InputEventGlyphMapper {
    static func glyph(for event: InputEvent) -> String? {
        switch event {
        case .keystroke:
            return nil
        case .mouse(let mouseEvent):
            return self.mouseDisplayText(for: mouseEvent.kind)
        case .mediaKey(let mediaKey):
            return self.mediaKeyGlyph(for: mediaKey)
        }
    }

    static func mouseDisplayText(for kind: MouseEvent.Kind) -> String {
        switch kind {
        case .leftButton:
            return "LMB"
        case .rightButton:
            return "RMB"
        case .middleButton:
            return "MMB"
        case let .otherButton(number):
            return "MB\(number)"
        case .wheelUp:
            return "MWHEELUP"
        case .wheelDown:
            return "MWHEELDOWN"
        case .wheelRight:
            return "MWHEELRIGHT"
        case .wheelLeft:
            return "MWHEELLEFT"
        case .generic:
            return "MB"
        }
    }

    static func mediaKeyGlyph(for event: MediaKeyEvent) -> String {
        switch event.kind {
        case .soundUp:            return UnicodeToken.speakerHigh.string
        case .soundDown:          return UnicodeToken.speakerLow.string
        case .mute:               return UnicodeToken.speakerMuted.string
        case .brightnessUp:       return UnicodeToken.brightnessUp.string
        case .brightnessDown:     return UnicodeToken.brightnessDown.string
        case .illuminationUp:     return UnicodeToken.keyboard.string + UnicodeToken.emojiPresentation.string + UnicodeToken.plus.string
        case .illuminationDown:   return UnicodeToken.keyboard.string + UnicodeToken.emojiPresentation.string + UnicodeToken.minus.string
        case .illuminationToggle: return UnicodeToken.keyboard.string + UnicodeToken.emojiPresentation.string
        case .play:               return UnicodeToken.playPause.string
        case .next:               return UnicodeToken.nextTrack.string
        case .previous:           return UnicodeToken.previousTrack.string
        case .fast:               return UnicodeToken.fastForward.string
        case .rewind:             return UnicodeToken.rewind.string
        case .eject:              return UnicodeToken.eject.string
        case .unknown:            return UnicodeToken.musicNote.string
        }
    }
}
