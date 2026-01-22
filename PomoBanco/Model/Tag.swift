//
//  Tag.swift
//  PomoBanco
//
//  Created by Belish Genin on 1/21/26.
//

import Foundation
import SwiftData

@Model
final class Tag {
    var id: UUID
    var name: String              // display name
    var normalizedName: String    // lowercase, trimmed
    var color: String
    var createdAt: Date

    init(name: String, color: String) {
        let clean = name.trimmingCharacters(in: .whitespacesAndNewlines)

        self.id = UUID()
        self.name = clean
        self.normalizedName = clean.lowercased()
        self.color = color
        self.createdAt = .now
    }
}
