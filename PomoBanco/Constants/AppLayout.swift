//
//  AppLayout.swift
//  PomoBanco
//
//  Spacing, padding, corner radius, and layout sizes.
//

import CoreGraphics

enum AppLayout {

    // Spacing

    static let spacingTight: CGFloat = 4
    static let spacingSmall: CGFloat = 8
    static let spacingMedium: CGFloat = 12
    static let spacingLarge: CGFloat = 16
    static let spacingStack: CGFloat = 20
    static let spacingSection: CGFloat = 24

    // Padding

    static let paddingTight: CGFloat = 6
    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 10
    static let paddingStandard: CGFloat = 12
    static let paddingRowHorizontal: CGFloat = 14
    static let paddingScreenHorizontal: CGFloat = 16
    static let paddingBottomSheet: CGFloat = 24

    // Corner radius

    static let cornerRadiusSmall: CGFloat = 10
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusCard: CGFloat = 16
    static let cornerRadiusRow: CGFloat = 20
    static let cornerRadiusPill: CGFloat = 25

    // Heights and Sizes

    static let headerRowHeight: CGFloat = 48
    static let workspaceHeaderHeight: CGFloat = 72
    static let tagDotSize: CGFloat = 20
    static let rowHeightCompact: CGFloat = 40
    static let rowHeightExpanded: CGFloat = 55

    // Timer area
    static let timerTopPadding: CGFloat = 12
    static let timerSizeMax: CGFloat = 280
    static let timerLift: CGFloat = -60
    static let timerBlurRadius: CGFloat = 3
    static let timerBlurRadiusPeek: CGFloat = 10
    static let timerDisplayWidth: CGFloat = 200
    static let timerDisplayHeight: CGFloat = 300
    static let timerBottomExtra: CGFloat = 70
    static let timerButtonSize: CGFloat = 38

    // Tomato (3D) fallback when RealityKit fails
    static let tomatoFallbackWidth: CGFloat = 300
    static let tomatoFallbackHeight: CGFloat = 350

    // Chart
    static let chartHeight: CGFloat = 200
    static let chartBarCornerRadius: CGFloat = 50
    static let chartLabelWidth: CGFloat = 60
}
