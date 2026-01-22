//
//  ChartView.swift
//  PomoBanco
//
//  Created by Belish Genin on 11/1/24.
//

import SwiftUI
import SwiftData
import Charts

struct ChartView: View {
    var project: Project
    @State private var currentWeek: Date = .now
    
    
    private var barColor: Color {
        Color.from(name: project.tag?.color ?? "red")
    }

    struct DailyDuration: Identifiable {
        let id = UUID()
        let date: Date
        let duration: Float
    }
    
  
    var body: some View {
        VStack {
            Chart {
                ForEach(get()) { dailyData in
                    BarMark(
                        x: .value("Date", dailyData.date, unit: .day),
                        y: .value("Duration", Double(dailyData.duration))
                    )
                    
                    .foregroundStyle(barColor)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisGridLine()
                    AxisTick()
                    
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                        .foregroundStyle(.white)

                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
                
            }
            .foregroundStyle(.white)

            .frame(height: 250)
            .padding()
            .background(.darkPink)
        }
    }

    
    private func get() -> [DailyDuration] {
        let durationByDate = project.durationPerDay(for: project)  // This is fine now if it's an instance method
        // or if it's a static method:
        // let durationByDate = Project.durationPerDay(for: project)
        
        let calendar = Calendar.current
        var weekDates: [Date] = []
        
        for dayOffset in -6...0 {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: currentWeek) else {
                continue
            }
            let startOfDay = calendar.startOfDay(for: date)  // Normalize the date here too
            weekDates.append(startOfDay)
        }
        
        return weekDates.map { date in
            DailyDuration(
                date: date,
                duration: durationByDate[date] ?? 0
            )
        }
    }

    
    private func changeCurrentWeek() {
        // with tap of button left or right arrows, increment week by 1
    }
}

private func createSampleProject() -> Project {
    
    
    let tag = Tag(
        name: "sample",
        color: "red"
        )
    
    let project = Project(
        id: UUID(),
        name: "Sample Project",
        details: "A project with sample entries for chart preview",
        complete: false,
        startDate: .now,
        tag: tag,
        endDate: nil,
        entries: []
    )
    
    let calendar = Calendar.current
    let sampleEntries = [
        Entry(date: .now, duration: 10005),
        Entry(date: .now, duration: 10005),
        Entry(date: calendar.date(byAdding: .day, value: -1, to: .now) ?? .now, duration: 1000),
        Entry(date: calendar.date(byAdding: .day, value: -1, to: .now) ?? .now, duration: 1.0),
        Entry(date: calendar.date(byAdding: .day, value: -2, to: .now) ?? .now, duration: 3.0),
        Entry(date: calendar.date(byAdding: .day, value: -3, to: .now) ?? .now, duration: 2.5),
        Entry(date: calendar.date(byAdding: .day, value: -4, to: .now) ?? .now, duration: 1.5)
    ]
    
    project.entries = sampleEntries
    return project
}

#Preview("ChartView") {
    let container = try! ModelContainer(for: Project.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    ChartView(project: createSampleProject())
        .modelContainer(container)
}
