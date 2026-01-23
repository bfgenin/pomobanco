//
//  PreviewSamples.swift
//  PomoBanco
//
//  Created by Belish Genin on 1/22/26.
//

#if DEBUG
import Foundation
import SwiftData

enum PreviewSamples {

    static func makeContainer() -> ModelContainer {
         let config = ModelConfiguration(isStoredInMemoryOnly: true)
         return try! ModelContainer(for: Project.self, configurations: config)
     }

    @MainActor static func seed(_ container: ModelContainer) {
        let ctx = container.mainContext
        ctx.insert(sampleProject())
        
        for project in sampleProjects() {
            ctx.insert(project)
        }


     }
    
    static func sampleProjects() -> [Project] {
        
        
        let tag = Tag(name: "health", color: "blue")
        let tag2 = Tag(name: "work", color: "red")
        
        
        let project1 = Project(id: UUID(), name: "name 1", details: "test one", startDate: .now, tag: tag, entries: [])
        let project2 = Project(id: UUID(), name: "name 2", details: "test two", startDate: .now, tag: tag2, entries: [])
        let project3 = Project(id: UUID(), name: "name 3", details: "test 3", startDate: .now,  tag: tag, entries: [])
        
        let projects = [project1, project2, project3]
        
        return projects
    }
    static func sampleProject() -> Project {
        let tag = Tag(name: "sample", color: "red")

        let calendar = Calendar.current
        let now = Date()

        // Start the project 5 weeks ago
        let startDate = calendar.date(byAdding: .weekOfYear, value: -5, to: now) ?? now

        let project = Project(
            id: UUID(),
            name: "Sample Project",
            details: "A project with sample entries across multiple weeks for chart preview",
            complete: false,
            startDate: startDate,
            tag: tag,
            endDate: nil,
            entries: []
        )

        func daysAgo(_ n: Int) -> Date {
            calendar.date(byAdding: .day, value: -n, to: now) ?? now
        }

        project.entries = [
            // This week
            Entry(date: daysAgo(0), duration: 1800),   // 30m
            Entry(date: daysAgo(0), duration: 2700),   // 45m
            Entry(date: daysAgo(1), duration: 900),    // 15m
            Entry(date: daysAgo(2), duration: 7200),   // 2h
            Entry(date: daysAgo(4), duration: 3600),   // 1h

            // Last week
            Entry(date: daysAgo(7), duration: 5400),   // 1.5h
            Entry(date: daysAgo(8), duration: 1200),   // 20m
            Entry(date: daysAgo(10), duration: 10800), // 3h

            // 2 weeks ago
            Entry(date: daysAgo(14), duration: 600),   // 10m
            Entry(date: daysAgo(16), duration: 14400), // 4h
            Entry(date: daysAgo(18), duration: 2400),  // 40m

            // 3 weeks ago (intentionally sparse)
            Entry(date: daysAgo(21), duration: 3600),  // 1h
            Entry(date: daysAgo(23), duration: 1800),  // 30m

            // 4 weeks ago
            Entry(date: daysAgo(28), duration: 21600), // 6h
            Entry(date: daysAgo(29), duration: 1200),  // 20m
            Entry(date: daysAgo(31), duration: 4800),  // 1h20m

            // 5 weeks ago (near project start)
            Entry(date: daysAgo(35), duration: 900),   // 15m
            Entry(date: daysAgo(36), duration: 3600)   // 1h
        ]

        return project
    }
}
#endif
