//
//  AppConstants.swift
//  PomoBanco
//
//  Central place for limits, defaults, and magic numbers.
//  Add this file to your Xcode target if the Constants group is new.
//

import Foundation

enum AppConstants {

    // MARK: - Project

    /// Max length for project name (title).
    static let projectTitleLimit = 20
    /// Max length for project description.
    static let projectDescriptionLimit = 100

    // MARK: - Tags

    /// Default tag color when project has no tag (must be one of tagColorPalette).
    static let defaultTagColor = "red"
    /// Tag names to seed when the user first adds a project (if no tags exist).
    static let defaultTagNames = ["Work", "Personal", "Health", "School"]
    /// All supported tag color names (must match Color.from(name:) in Color+Extensions).
    static let tagColorPalette = [
        "red", "pink", "purple", "green", "blue",
        "yellow", "orange", "brown", "gray",
    ]

    // MARK: - Timer

    /// Default countdown duration in minutes.
    static let timerDefaultMinutes: Float = 25
    /// Preset work durations in minutes (for picker).
    static let timerPresetMinutes: [Float] = [25, 35, 45]
    /// Timer tick interval in seconds.
    static let timerTickInterval: TimeInterval = 1
    /// Default countdown display string (e.g. "25:00").
    static var timerDefaultTimeString: String {
        "\(Int(timerDefaultMinutes)):00"
    }
    /// Reset stopwatch display string.
    static let timerResetTimeString = "00:00"

    // MARK: - Time format strings (for String(format:))

    /// Format for countdown display: minutes:seconds (e.g. "5:03").
    static let timeFormatMinutesSeconds = "%d:%02d"
    /// Format for time display with leading zeros: "05:03".
    static let timeFormatPaddedMinutesSeconds = "%02d:%02d"
    /// Format for stopwatch with hours: "01:30:45".
    static let timeFormatHoursMinutesSeconds = "%02d:%02d:%02d"
}
