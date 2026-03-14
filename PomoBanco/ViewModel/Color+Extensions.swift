//
//  Color+Extensions.swift
//  PomoBanco
//
//  Created by Belish Genin on 1/21/26.
//

import Foundation
import SwiftUICore

extension Color {
    /// Maps tag color names (from AppConstants.tagColorPalette) to SwiftUI colors.
    static func from(name: String) -> Color {
        switch name {
        case "red": return .red
        case "blue": return .blue
        case "pink": return .pink
        case "purple": return .purple
        case "green": return .green
        case "orange": return .orange
        case "teal": return .teal
        case "yellow": return .yellow
        case "brown": return .brown
        case "gray": return .gray
        default: return .gray
        }
    }
}
