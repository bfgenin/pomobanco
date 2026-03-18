//
//  PreviewSamples.swift
//  PomoBanco
//
//  Created by Belish Genin on 1/22/26.


import Foundation
import SwiftData

#if DEBUG
enum PreviewSamples {

    static func makeContainer() -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: Project.self, Entry.self, Tag.self, configurations: config)
    }

    @MainActor static func seed(_ container: ModelContainer) async {
        let ctx = container.mainContext
        ctx.insert(sampleProject())
        for project in sampleProjects() {
            ctx.insert(project)
        }
    }

    private static func daysAgo(_ n: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -n, to: .now) ?? .now
    }

    private static func weeksAgo(_ n: Int) -> Date {
        Calendar.current.date(byAdding: .weekOfYear, value: -n, to: .now) ?? .now
    }

    static func generateEntries(for project: Project) {
        let daysSinceStart = Calendar.current.dateComponents([.day], from: project.startDate, to: .now).day ?? 14
        let range = min(daysSinceStart, 14)

        project.entries = (0..<range).flatMap { daysBack -> [Entry] in
            let entryCount = Int.random(in: 0...3)
            return (0..<entryCount).map { _ in
                let duration = Int.random(in: 25...150) * 60
                return Entry(date: daysAgo(daysBack), duration: Float(duration))
            }
        }
    }

    static func sampleProjects() -> [Project] {
        let work = Tag(name: "work", color: "red")
        let school = Tag(name: "school", color: "green")
        let research = Tag(name: "research", color: "purple")

        let project1 = Project(id: UUID(), name: "WordHop", details: "Development work on wordhop the word relationship game", startDate: weeksAgo(8), tag: work, entries: [])
        let project2 = Project(id: UUID(), name: "Math Academy", details: "Progressing through Math Academy's Math for Machine Learning course", startDate: weeksAgo(3), tag: school, entries: [])
        let project3 = Project(id: UUID(), name: "Early Computers", details: "Reading into the early history of computers", startDate: weeksAgo(12), tag: research, entries: [])
        let project4 = Project(id: UUID(), name: "Sample No Tag", details: "a sample project with no tag", startDate: weeksAgo(1), entries: [])

        [project1, project2, project3, project4].forEach { generateEntries(for: $0) }

        return [project1, project2, project3, project4]
    }

    static func sampleProject() -> Project {
        let project = Project(
            id: UUID(),
            name: "Sample Project",
            details: "A project with sample entries across multiple weeks for chart preview",
            complete: false,
            startDate: weeksAgo(5),
            tag: Tag(name: "sample", color: "red"),
            endDate: nil,
            entries: []
        )

        project.entries = [
            Entry(date: daysAgo(0),  duration: 1800),
            Entry(date: daysAgo(0),  duration: 2700),
            Entry(date: daysAgo(1),  duration: 900),
            Entry(date: daysAgo(2),  duration: 7200),
            Entry(date: daysAgo(4),  duration: 3600),
            Entry(date: daysAgo(7),  duration: 5400),
            Entry(date: daysAgo(8),  duration: 1200),
            Entry(date: daysAgo(10), duration: 10800),
            Entry(date: daysAgo(14), duration: 600),
            Entry(date: daysAgo(16), duration: 14400),
            Entry(date: daysAgo(18), duration: 2400),
            Entry(date: daysAgo(21), duration: 3600),
            Entry(date: daysAgo(23), duration: 1800),
            Entry(date: daysAgo(28), duration: 21600),
            Entry(date: daysAgo(29), duration: 1200),
            Entry(date: daysAgo(31), duration: 4800),
            Entry(date: daysAgo(35), duration: 900),
            Entry(date: daysAgo(36), duration: 3600),
        ]

        return project
    }
}
#endif
