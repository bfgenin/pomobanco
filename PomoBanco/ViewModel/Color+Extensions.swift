//
//  Color+Extensions.swift
//  PomoBanco
//
//  Created by Belish Genin on 1/21/26.
//

import Foundation
import SwiftUICore

extension Color {
    static func from(name: String) -> Color {
        switch name {
        case "red": return .red
        case "blue": return .blue
        case "pink": return .pink
        case "purple": return .purple
        case "green": return .green
        case "orange": return .orange
        case "teal": return .teal
        default: return .gray
        }
    }
}
