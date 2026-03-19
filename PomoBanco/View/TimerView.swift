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

    
    @Binding var isTimerRunning: Bool

    /// Tracks whether the user has started a session.
    /// This lets us reset time when the selected project is dismissed
    /// without accidentally resetting the default timer before any session starts.
    @State private var sessionStarted = false
    
    let timer = Timer.publish(every: AppConstants.timerTickInterval, on: .main, in: .common).autoconnect()
    let width: Double = AppLayout.timerDisplayWidth
    let presetWorkTime: [Float] = AppConstants.timerPresetMinutes
    
    var project: Project? // project to acccumlate time to

    @Binding var focusMode: Bool
    @State var editTimer: Bool = false
    @State private var showSkipAlert = false

    // offset/drag effects
    @State private var x_offset: CGFloat = 0.0
    @State private var y_offset: CGFloat = 0.0
    private let maxDragDistance: CGFloat = 50.0 // adjust to change the max length of the drag/swipe gestures
    
    private let maxDragDistanceVert: CGFloat = 10.0
    
    var body: some View {
        
        ZStack {
            TomatoView(focusMode: $focusMode)
                .frame(maxWidth: .infinity, maxHeight: AppLayout.timerDisplayHeight)
                .offset(y: 20)
                .scaleEffect(2.4)
            VStack(spacing: AppLayout.spacingStack) {
                TimerTextDisplay(
                    text: focusMode ? vm.stopWatchTime : vm.time,
                    focusMode: focusMode,
                    width: width
                )

                if editTimer && !focusMode {
                    Picker("Select Time", selection: $vm.minutes) {
                        ForEach(presetWorkTime, id: \.self) {
                            Text("\(Int($0)):00")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .frame(width: width)
                    .pickerStyle(.palette)
                    .colorScheme(.dark)
                    .disabled(vm.isActive)
       
                } else {
                    TimerControls(
                        focusMode: focusMode,
                        isActive: vm.isActive,
                        hasProject: project != nil,
                        width: width,
                        onStart: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                vm.start(minutes: focusMode ? 0.0 : vm.minutes)
                                sessionStarted = true
                            }
                            editTimer = false
                        },
                        onPause: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                vm.pause()
                            }
                        },
                        onEnd: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                vm.pause()
                                
                                addTime(time: vm.elapsedTime)
                                focusMode ? vm.reset() : vm.end()
                                sessionStarted = false
                            }
                        },
                        onSkip: {
                            showSkipAlert = true
                            
                        }
                    )
                }
            }
            .offset(y: -30)
                
        }
        .offset(x: x_offset, y: y_offset)
        .onReceive(timer) { _ in
            if focusMode {
                vm.updateStopwatch()
            } else {
                vm.updateCountdown()
            }
        }
        .alert(AppStrings.areYouSure, isPresented: $showSkipAlert) {
            Button(AppStrings.cancel, role: .cancel) {}
            Button(AppStrings.skipSession, role: .destructive) {
                if focusMode {
                    vm.reset()
                } else {
                    vm.end()
                }
                sessionStarted = false
            }
        } message: {
            Text(AppStrings.skipSessionMessage)
        }
        .onChange(of: vm.isActive) { _, newValue in
            isTimerRunning = newValue
        }
        .onChange(of: project?.id) { _, newProjectID in
            // If the user dismisses/de-selects the project while a session has started
            // (even if paused), reset time as if "Skip session" was chosen.
            if newProjectID == nil, sessionStarted {
                withAnimation(.easeInOut(duration: 0.25)) {
                    if focusMode {
                        vm.reset()
                    } else {
                        vm.end()
                    }
                    sessionStarted = false
                }
            }
        }
        .frame(maxWidth: .infinity,maxHeight: 300)
        .clipped()
        .padding()
        .gesture(vm.isActive ? nil : dragGesture())
    }
    private func addTime(time: Float) {
        let entry = Entry(date: Date.now, duration: time)
        
        // Ensure task is mutable and add the entry
        guard let project = project else { return }
        
        project.addEntry(entry)
        print("Task: \(project.name) Entry Date: \(entry.date)  Entry Time\(entry.duration)")
         do {
             // Save the context if needed
             try modelContext.save()
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
             y_offset = min(max(verticalDrag, -maxDragDistanceVert), maxDragDistanceVert)
             x_offset = 0 // Reset horizontal offset
         }
     }

     private func handleDragEnded(_ value: DragGesture.Value) {
         withAnimation(.spring()) {
             print("h: \(value.translation.width), v: \(value.translation.height)")
             if abs(value.translation.width) > 30 {
                 let newFocusMode = value.translation.width > 0 ? false : true
                 if newFocusMode == true {
                     editTimer = false  // only reset when switching INTO focus mode
                 }
                 focusMode = newFocusMode
             } else if value.translation.height < -10 {
                 editTimer = true
             } else if value.translation.height > 10 {
                 editTimer = false
             }
             // reset offsets
             x_offset = 0.0
             y_offset = 0.0
         }
     }
}

// TimerTextDisplay.swift
struct TimerTextDisplay: View {
    let text: String
    let focusMode: Bool
    let width: Double

    var gradientColors: [Color] {
        focusMode
        ? [Color.darkBlue, Color.hotPurple]
            : [Color.darkPink, Color.hotPink]
    }
    var body: some View {
        Text(text)
            .font(AppTheme.copperplate(size: AppTheme.copperplateTimer))
            .monospacedDigit()
            .frame(width: width, alignment: .center)
            .minimumScaleFactor(0.8)
            .lineLimit(1)
            .foregroundColor(.clear)
            .overlay(
                LinearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom)
                    .mask(
                        Text(text)
                            .font(AppTheme.copperplate(size: AppTheme.copperplateTimer))
                            .monospacedDigit()
                            .frame(width: width, alignment: .center)
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                    )
            )
            .shadow(color: focusMode ? .pink.opacity(0.9) : .purple.opacity(0.9), radius: 0, x: 0, y: 2)
            .shadow(color: focusMode ? .pink.opacity(0.5) : .purple.opacity(0.5), radius: 4, x: 0, y: 4)
            .contentTransition(.numericText())
            .animation(.spring(duration: 0.4), value: focusMode)
    }
}


// TimerControls.swift
struct TimerButtonStyle: ButtonStyle {
    let focusMode: Bool
    let isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed
        let size = AppLayout.timerButtonSize
        
        let gradientColors: [Color] = focusMode
        ? [Color.darkBlue, Color.hotPurple]
        : [Color.darkPink, Color.hotPink]
        
        let bedColor: Color = focusMode ? Color.hotPurple : Color.hotPink
        
        configuration.label
            .font(AppTheme.system(size: AppTheme.systemButton, weight: .semibold))
            .frame(width: size, height: size)
            .foregroundStyle(isDisabled ? Color.white.opacity(0.3) : Color.white)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: AppLayout.cornerRadiusSmall)
                        .fill(bedColor)
                    RoundedRectangle(cornerRadius: AppLayout.cornerRadiusSmall)
                        .fill(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    RoundedRectangle(cornerRadius: AppLayout.cornerRadiusSmall)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.1), Color.clear],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                    
                }
            )
            .shadow(
                color: (focusMode ? Color.hotPink : Color.hotPurple).opacity(isDisabled ? 0 : 0.5),
                radius: pressed ? 2 : 6,
                x: 0,
                y: pressed ? 1 : 4
            )
            .animation(.spring(response: 0.18, dampingFraction: 0.65), value: pressed)
    }
}

struct TimerControls: View {
    let focusMode: Bool
    let isActive: Bool
    let hasProject: Bool
    let width: Double
    let onStart: () -> Void
    let onPause: () -> Void
    let onEnd: () -> Void
    let onSkip: () -> Void

    var body: some View {
        HStack(spacing: AppLayout.spacingLarge) {
            Button(action: onStart) {
                Image(systemName: "play.fill")
            }
            .buttonStyle(TimerButtonStyle(focusMode: focusMode, isDisabled: isActive || !hasProject))
            .disabled(isActive || !hasProject)

            Button(action: onPause) {
                Image(systemName: "pause.fill")
            }
            .buttonStyle(TimerButtonStyle(focusMode: focusMode, isDisabled: !isActive))
            .disabled(!isActive)
            Button(action: onEnd) {
                Image(systemName: "stop.circle.fill")
            }
            .buttonStyle(TimerButtonStyle(focusMode: focusMode, isDisabled: !isActive))
            .disabled(!isActive)

            Button(action: onSkip) {
                Image(systemName: "forward.end.fill")
            }
            .buttonStyle(TimerButtonStyle(focusMode: focusMode, isDisabled: !isActive))
            .disabled(!isActive)
        }
    }
}

#Preview {
    let container = PreviewSamples.makeContainer()
    let previewProject = Project(
        id: UUID(),
        name: "Preview Project",
        details: "Details For Preview Project",
        startDate: .now,
        entries: []
    )
    container.mainContext.insert(previewProject)

    struct PreviewWrapper: View {
        let project: Project
        @State var isTimerRunning = false
        @State var focusMode = false

        var body: some View {
            TimerView(
                isTimerRunning: $isTimerRunning, project: project,
                focusMode: $focusMode
            )
        }
    }

    return PreviewWrapper(project: previewProject)
        .modelContainer(container)
}
