import Foundation
import SwiftData

@Model
final class Task {
    let id = UUID()
    var name: String
    var details: String
    var time = 0.0
    var complete = false
    
    @Relationship(deleteRule: .nullify, inverse: \Project.tasks)
    var project: Project?
    
    var entries: [Entry] {
        didSet {
            // Sum all seconds stored in entries.duration
            self.time = entries.reduce(0) { $0 + $1.duration }
        }
    }
    
    init(name: String, details: String, time: Double = 0.0, complete: Bool = false, project: Project? = nil, entries: [Entry]) {
        self.name = name
        self.details = details
        self.time = time
        self.complete = complete
        self.project = project
        self.entries = entries
    }
    
   static let example = Task(name: "Test Task", details: "This is a Test Task", time: 0, entries: [Entry]())
}
