//
//  TagModel.swift
//  PomoBanco
//
//  Created by Belish Genin on 1/21/26.
//

import Foundation
import SwiftUI
import SwiftData

enum TagModel {

    static func normalized(_ name: String) -> String {
        name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }

    static func createOrFetch(
        name: String,
        context: ModelContext
    ) -> Tag {

        let clean = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalized = clean.lowercased()

        let descriptor = FetchDescriptor<Tag>(
            predicate: #Predicate {
                $0.normalizedName == normalized
            }
        )

        if let existing = try? context.fetch(descriptor).first {
            return existing
        }

        let newTag = Tag(
            name: clean,
            color: nextAvailableColor(context: context)
        )

        context.insert(newTag)
        try? context.save()

        return newTag
    }
    
    static func nextAvailableColor(context: ModelContext) -> String {
        let palette = AppConstants.tagColorPalette
        let usedColors = (try? context.fetch(FetchDescriptor<Tag>()))?
            .map { $0.color } ?? []
        return palette.first { !usedColors.contains($0) } ?? palette.randomElement()!
    }
}
