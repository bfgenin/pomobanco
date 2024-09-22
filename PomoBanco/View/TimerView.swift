//
//  TimerView.swift
//  PomoBanco
//
//  Created by Belish Genin on 9/20/24.
//
import SwiftUI
import SwiftData

struct TimerView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject private var vm = TimerModel()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let presetWorkTime: [Float] = [25.0, 35.0, 45.0]
     
    let width: Double = 200
    var task: Task?

    @Binding var focusMode: Bool
    @State var editTimer: Bool = false
    
    @State private var x_offset: CGFloat = 0.0
    @State private var y_offset: CGFloat = 0.0
    private let maxDragDistance: CGFloat = 50.0
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 20) {
                Text("\(vm.time)")
                    .frame(width: width)
                    .font(Font.system(size: 70).monospacedDigit())
                    .foregroundColor(focusMode ? Color.darkPink : Color.darkBlue)
                
                
                if editTimer {
                    Picker("Select Time", selection: $vm.minutes) {
                        ForEach(presetWorkTime, id: \.self) {
                            Text("\(Int($0)):00")
                                .foregroundColor(focusMode ? Color.darkPink : Color.darkBlue)
                        }
                    }
                    .frame(width: width)
                    .pickerStyle(.palette)
                    .background(focusMode ? Color.darkPink.opacity(0.1) : Color.darkBlue.opacity(0.1))
                    .disabled(vm.isActive)
                }
         
                
                HStack(spacing: 30) {
                    Button("Confirm") {
                        vm.start(minutes: vm.minutes)
                        editTimer = false
                    }
                    .disabled(vm.isActive || task == nil)
                    Button("Reset") {
                        let elapsed = vm.elapsedTime
                        addTime(time: elapsed)
                        vm.reset()
                    }
                    .tint(.red)
                    .disabled(!vm.isActive)
                }
                .frame(width: width)
            }
                
        }
        .onReceive(timer) { _ in
            vm.updateCountdown()
        }
        .frame(width: 300, height: 300)
        .background(focusMode ? Color.darkBlue : Color.darkPink)
        .clipShape(RoundedRectangle(cornerRadius: 100, style: .circular))
        .offset(x: x_offset, y: y_offset) // Use offset for slide effect
        .padding()
        .gesture(dragGesture())
    }
    
    private func addTime(time: Float) {
        let entry = Entry(date: Date.now, duration: time)
        
        // Ensure task is mutable and add the entry
        guard let task = task else { return }
        task.addEntry(entry)// Adjust according to your Task structure
        print("Task: \(task.name) Entry Date: \(entry.date)  Entry Time\(entry.duration)")
         do {
             // Save the context if needed
             try modelContext.save() // Ensure you save changes to the model context
         } catch {
             print("Failed to save entry: \(error.localizedDescription)")
         }
     }
     
    private func dragGesture() -> some Gesture {
          DragGesture()
              .onChanged { value in
                  handleDragChanged(value)
              }
              .onEnded { value in
                  handleDragEnded(value)
              }
      }

    private func handleDragChanged(_ value: DragGesture.Value) {
         let horizontalDrag = value.translation.width
         let verticalDrag = value.translation.height

         if abs(horizontalDrag) > abs(verticalDrag) {
             // Limit the offset to maxDragDistance for horizontal drag
             x_offset = min(max(horizontalDrag, -maxDragDistance), maxDragDistance)
             y_offset = 0 // Reset vertical offset
         } else {
             // Limit the offset to maxDragDistance for vertical drag
             y_offset = min(max(verticalDrag, -maxDragDistance), maxDragDistance)
             x_offset = 0 // Reset horizontal offset
         }
     }

     private func handleDragEnded(_ value: DragGesture.Value) {
         withAnimation(.spring()) {
             if abs(value.translation.width) > 30 {
                 focusMode = value.translation.width > 0 ? false : true
             } else if value.translation.height < 20 {
                 editTimer = true
             } else if value.translation.height > 20 {
                 editTimer = false
             }
             // Reset offsets
             x_offset = 0.0
             y_offset = 0.0
         }
     }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Task.self, configurations: config)
        let prevTask = Task(name: "Preview Task", details:  "Task for Preview", entries: [Entry]())
        return TimerView(task: prevTask, focusMode: .constant(false))
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
