import Foundation
import SwiftData

@Model
final class Project {
    let id = UUID()
    var name: String
    var details: String
    var time: Float {
        entries.reduce(0) { $0 + $1.duration }
    }
    var complete = false
    var startDate: Date
    var endDate: Date?
    var tasks: [Task]
    var entries: [Entry]
    var tag: String?
    
    func addEntry(_ entry: Entry) {
        self.entries.append(entry)
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        //task.project = self
    }
    
    func finishProject() {
        self.complete.toggle()
    }
    
    func formatTime(for date: Date) -> String {
        let calendar = Calendar.current
        
        // filter entries to find those matching given date
        let totalDuration = entries
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
            .reduce(0) { $0 + $1.duration }
        
        // convert from seconds to hours:minutes
        let totalSeconds = Int(totalDuration)
        let totalHours = totalSeconds / 3600
        let totalMinutes = (totalSeconds % 3600) / 60

        return String(format: "%02d:%02d", totalHours, totalMinutes)
    }
    
    
    init(id: UUID, name: String, details: String, complete: Bool = false, startDate: Date, endDate: Date? = nil, tasks: [Task], entries: [Entry]) {
        self.id = id 
        self.name = name
        self.details = details
        self.complete = complete
        self.startDate = startDate
        self.endDate = endDate
        self.tasks = tasks
        self.entries = entries
        self.tag = "health"
    }

    static let example = Project(id: UUID(), name: "Test Project", details: "This is a Test Project", startDate: .distantPast, tasks: [Task](), entries: [Entry]())
}
