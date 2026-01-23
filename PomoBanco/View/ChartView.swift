
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

    // store start-of-week
    @State private var weekStart: Date = Calendar.current.startOfWeek(for: .now)

    // chart renders
    @State private var displayWeekData: [DailyDuration] = []

    private var barColor: Color { Color.from(name: project.tag?.color ?? "red") }

    private var barGradient: LinearGradient {
        LinearGradient(
            colors: [barColor.opacity(0.95), barColor.opacity(0.55)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // 2 hours in seconds
    private let yStep: Double = 2 * 60 * 60

    struct DailyDuration: Identifiable, Equatable {
        let id: UUID
        let date: Date
        var duration: Double // seconds

        init(id: UUID = UUID(), date: Date, duration: Double) {
            self.id = id
            self.date = date
            self.duration = duration
        }
    }

    var body: some View {
        VStack(spacing: 2) {

            Text(weekLabel(weekStart))
                .foregroundStyle(.white.opacity(0.9))
                .font(.headline)
          
            Chart(displayWeekData) { d in
                BarMark(
                    x: .value("Date", d.date, unit: .day),
                    y: .value("Duration", d.duration)
                )
                .foregroundStyle(barGradient)
                .cornerRadius(6)
            }
            .chartYScale(domain: 0...yAxisMax(for: displayWeekData))
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisGridLine().foregroundStyle(.white.opacity(0.15))
                    AxisTick().foregroundStyle(.white.opacity(0.8))
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                        .foregroundStyle(.white)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .stride(by: yStep)) { value in
                    AxisGridLine().foregroundStyle(.white.opacity(0.25))
                    AxisTick().foregroundStyle(.white.opacity(0.8))
                    AxisValueLabel {
                        if let seconds = value.as(Double.self) {
                            Text("\(Int(seconds / 3600))h")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .frame(height: 250)
            .padding()

            // Buttons back
            HStack {
                Button { moveWeek(-1) } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .padding(8)
                        .foregroundStyle(.white)
                        .opacity(canGoPrev ? 1 : 0.35)
                }
                .buttonStyle(.plain)
                .disabled(!canGoPrev)

                Spacer()

                Button { moveWeek(1) } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .padding(8)
                        .foregroundStyle(.white)
                        .opacity(canGoNext ? 1 : 0.35)
                }
                .buttonStyle(.plain)
                .disabled(!canGoNext)
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
//        .background(.darkPink)
        .onAppear {
            refreshChart(animated: false)
        }
        .onChange(of: weekStart) { _, _ in
            refreshChart(animated: true)
        }
    }


    private func moveWeek(_ direction: Int) {
        let cal = Calendar.current
        guard let proposed = cal.date(byAdding: .day, value: 7 * direction, to: weekStart) else { return }

        let minWeek = cal.startOfWeek(for: project.startDate)
        let maxWeek = cal.startOfWeek(for: .now)

        let newWeek = min(max(proposed, minWeek), maxWeek)

        withAnimation(.snappy(duration: 0.25)) {
              weekStart = newWeek
          }
    }

    private var canGoPrev: Bool {
        Calendar.current.startOfWeek(for: weekStart) > Calendar.current.startOfWeek(for: project.startDate)
    }

    private var canGoNext: Bool {
        Calendar.current.startOfWeek(for: weekStart) < Calendar.current.startOfWeek(for: .now)
    }

    private func refreshChart(animated: Bool) {
        let real = makeWeekData()

        // keep IDs stable per date so bars animate instead of "replacing"
        let idByDate = Dictionary(uniqueKeysWithValues: displayWeekData.map { ($0.date, $0.id) })

        let realStable: [DailyDuration] = real.map { d in
            DailyDuration(id: idByDate[d.date] ?? d.id, date: d.date, duration: d.duration)
        }

        let zeros = realStable.map { DailyDuration(id: $0.id, date: $0.date, duration: 0) }

        // immediately jump to 0
        displayWeekData = zeros

        guard animated else {
            displayWeekData = realStable
            return
        }

        let dur = barAnimationDuration(for: realStable)
        withAnimation(.easeInOut(duration: dur).delay(0.05)) {
            displayWeekData = realStable
        }
    }

    private func barAnimationDuration(for data: [DailyDuration]) -> Double {
        let maxVal = data.map(\.duration).max() ?? 0
        let t = min(max(maxVal / (6 * 3600), 0), 1) // 0..1
        return 0.6 + (0.6 * t)                      // 0.6..1.2s
    }


    private func makeWeekData() -> [DailyDuration] {
        let byDay = project.durationPerDay(for: project)
        let cal = Calendar.current

        return (0..<7).compactMap { offset in
            guard let day = cal.date(byAdding: .day, value: offset, to: weekStart) else { return nil }
            let startOfDay = cal.startOfDay(for: day)
            let seconds = Double(byDay[startOfDay] ?? 0)
            return DailyDuration(date: startOfDay, duration: seconds)
        }
    }


    private func yAxisMax(for data: [DailyDuration]) -> Double {
        let rawMax = data.map(\.duration).max() ?? 0
        let minMax = 4 * 60 * 60.0
        let capped = max(rawMax, minMax)
        return ceil(capped / yStep) * yStep
    }

    // MARK: - Labels

    private func weekLabel(_ start: Date) -> String {
        let cal = Calendar.current
        let end = cal.date(byAdding: .day, value: 6, to: start) ?? start
        let fmt = DateFormatter()
        fmt.dateFormat = "MMM d"
        return "\(fmt.string(from: start)) – \(fmt.string(from: end))"
    }
}

private extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let comps = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: comps) ?? startOfDay(for: date)
    }
}


#Preview("ChartView") {
    let container = try! ModelContainer(
        for: Project.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    ChartView(project: PreviewSamples.sampleProject())
        .modelContainer(container)
}
