//
//  AppTheme.swift
//  PomoBanco
//
//  Fonts and typography.
//

import SwiftUI

enum AppTheme {

    private static let avenir = "Avenir"
    private static let copperplate = "Copperplate"

    // MARK: - Avenir (body, labels, UI)

    static func avenir(size: CGFloat) -> Font {
        .custom(avenir, size: size)
    }

    static let avenirCaption: CGFloat = 12
    static let avenirBody: CGFloat = 16
    static let avenirBodyLarge: CGFloat = 18
    static let avenirTitle: CGFloat = 20
    static let avenirHeadline: CGFloat = 24

    // MARK: - Copperplate (timer display)

    static func copperplate(size: CGFloat) -> Font {
        .custom(copperplate, size: size)
    }

    static let copperplateTimer: CGFloat = 70

    // MARK: - System (icons, buttons)

    static func system(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight)
    }

    static let systemButton: CGFloat = 16
}
