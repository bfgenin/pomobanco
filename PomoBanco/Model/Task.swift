import Foundation
import SwiftData

@Model
final class Task {
    let id = UUID()
    var name: String
    var details: String
    var time: Float {
        entries.reduce(0) { $0 + $1.duration }
    }
    var complete = false
    
    @Relationship(deleteRule: .nullify, inverse: \Project.tasks)
    var project: Project?
    
    var entries: [Entry]
   
    func addEntry(_ entry: Entry) {
        self.entries.append(entry)
    }
    
    init(name: String, details: String, complete: Bool = false, project: Project? = nil, entries: [Entry]) {
        self.name = name
        self.details = details
        self.complete = complete
        self.project = project
        self.entries = entries
    }
    
   static let example = Task(name: "Test Task", details: "This is a Test Task", entries: [Entry]())
    
}
