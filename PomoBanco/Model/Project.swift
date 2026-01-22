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
    var entries: [Entry]
    var tag: Tag?
    
    func addEntry(_ entry: Entry) {
        self.entries.append(entry)
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
    
    func durationPerDay(for project: Project) -> [Date: Float] {
        var dailyDuration: [Date: Float] = [:]
        let calendar = Calendar.current
        
        for entry in project.entries {
            // Normalize the date to start of day
            let startOfDay = calendar.startOfDay(for: entry.date)
            
            dailyDuration[startOfDay, default: 0] += entry.duration
        }
        return dailyDuration
    }

    init(id: UUID, name: String, details: String, complete: Bool = false, startDate: Date,
    tag: Tag? = nil, endDate: Date? = nil, entries: [Entry]) {
        self.id = id
        self.name = name
        self.details = details
        self.complete = complete
        self.startDate = startDate
        self.endDate = endDate
        self.entries = entries
        self.tag = tag
    }
    static let example = Project(id: UUID(), name: "Test Project", details: "This is a Test Project", startDate: .distantPast, entries: [Entry]())
    
}
