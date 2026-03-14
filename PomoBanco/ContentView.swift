import SwiftUI
import SwiftData

// MARK: - Preference Keys

private struct TimerBoundsKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue() ?? value
    }
}

private struct SelectedProjectBoundsKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue() ?? value
    }
}

private struct ProjectListBoundsKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue() ?? value
    }
}

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query private var projects: [Project]
    
    @State private var selectedProject: Project? = nil
    @State private var isExpanded = false
    @State private var isAdding = false
    @State private var bottomShow = false
    @State private var topShow = false
    @State private var isTimerRunning = false
    @State private var focusMode = false
    
    @State private var showDebugFrames = true
    
    @State private var timerBottomY: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            
            let safeTop = geo.safeAreaInsets.top
            let safeBottom = geo.safeAreaInsets.bottom
            let screenH = geo.size.height
            let screenW = geo.size.width
            
            let timerTopPadding: CGFloat = 12
            let timerGap: CGFloat = 12
            let timerSize = min(280, screenW * 0.62)
            let timerLift: CGFloat = -60
            
            let fallbackBottom = safeTop + timerTopPadding + timerSize
            let effectiveTimerBottom = timerBottomY == 0 ? fallbackBottom : timerBottomY
            
            let workspaceTop = effectiveTimerBottom // timerGap
            let workspaceHeight = max(0, screenH - workspaceTop)
            
            ZStack {
                
                BlurBackground(focusMode: focusMode)
                    .ignoresSafeArea()
                
                WorkspaceLayer(
                    workspaceTop: workspaceTop,
                    workspaceHeight: workspaceHeight,
                    safeBottom: safeBottom,
                    isTimerRunning: isTimerRunning,
                    projects: projects,
                    selectedProject: $selectedProject,
                    isExpanded: $isExpanded,
                    isAdding: $isAdding,
                    bottomShow: $bottomShow,
                    showDebugFrames: showDebugFrames
                    
                )
                .blur(radius: isTimerRunning && focusMode ? 3 : 0)
                .blur(radius: topShow ? 10 : 0)
                .animation(.easeInOut(duration: 0.8), value: isTimerRunning)
                .zIndex(5)
                
                .overlay(alignment: .top) {
                    TimerLayer(
                        isTimerRunning: $isTimerRunning,
                        selectedProject: selectedProject,
                        focusMode: $focusMode,
                        timerTopPadding: timerTopPadding,
                        timerLift: timerLift,
                        topShow: $topShow
                    )
                    .zIndex(10)
                }
            }
            
            .overlayPreferenceValue(TimerBoundsKey.self) { anchor in
                GeometryReader { proxy in
                    if let anchor {
                        let rect = proxy[anchor]
                        Color.clear
                            .onAppear { timerBottomY = rect.maxY }
                            .onChange(of: rect.maxY) { _, newValue in
                                timerBottomY = newValue
                            }
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

private struct TimerLayer: View {
    
    @Binding var isTimerRunning: Bool
    var selectedProject: Project?
    @Binding var focusMode: Bool
    
    let timerTopPadding: CGFloat
    let timerLift: CGFloat
    @Binding var topShow: Bool
    
    var body: some View {
        VStack {
            TimerView(
                isTimerRunning: $isTimerRunning,
                project: selectedProject,
                focusMode: $focusMode
            )
            .anchorPreference(key: TimerBoundsKey.self, value: .bounds) { $0 }
            .shadow(
                color: (focusMode ? Color.hotPurple : Color.hotPink).opacity(0.9),
                radius: 50, x: 2, y: 1
            )
            .padding(.top, timerTopPadding)
            .contentShape(Rectangle())
            
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .offset(y: topShow ? -timerLift : 0)
    }}

private struct WorkspaceLayer: View {
    
    let workspaceTop: CGFloat
    let workspaceHeight: CGFloat
    let safeBottom: CGFloat
    let isTimerRunning: Bool
    
    let projects: [Project]
    
    @Binding var selectedProject: Project?
    @Binding var isExpanded: Bool
    @Binding var isAdding: Bool
    @Binding var bottomShow: Bool
    
    let showDebugFrames: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            WorkspaceContent(
                workspaceHeight: workspaceHeight,
                safeBottom: safeBottom,
                projects: projects,
                isTimerRunning: isTimerRunning,
                selectedProject: $selectedProject,
                isExpanded: $isExpanded,
                isAdding: $isAdding,
                bottomShow: $bottomShow
            )
            .padding(.top, workspaceTop)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .animation(.spring(response: 0.55, dampingFraction: 0.85), value: isExpanded)
            .animation(.spring(response: 0.55, dampingFraction: 0.85), value: isAdding)
        }
    }
}

private struct WorkspaceContent: View {
    
    let workspaceHeight: CGFloat
    let safeBottom: CGFloat
    let projects: [Project]
    let isTimerRunning: Bool
    
    @Binding var selectedProject: Project?
    @Binding var isExpanded: Bool
    @Binding var isAdding: Bool
    @Binding var bottomShow: Bool
    
    private let headerHeight: CGFloat = 72
    
    var body: some View {
        VStack(spacing: 0) {
            
            AddNewProject(isExpanded: $isAdding)
                .padding(.horizontal, 16)
                .opacity(isExpanded ? 0 : 1)
                .frame(height: isExpanded ? 0 : nil)
                .clipped()
                .disabled(isTimerRunning)
            
            SelectedProjectView(
                selectedProject: $selectedProject,
                isExpanded: $isExpanded,
                maxExpandedHeight: workspaceHeight,
                collapsedHeight: headerHeight
            )
            .padding(.horizontal, 16)
            .frame(
                height: isAdding ? 0 : (isExpanded ? .infinity : headerHeight),
                alignment: .top
            )
            .opacity(isAdding ? 0 : 1)
            .clipped()
            
            if !isExpanded && !isAdding {
                Spacer(minLength: 16)
            }
            
            Spacer(minLength: 0)
            
            ProjectListView(
                bottomShow: $bottomShow,
                selectedProject: $selectedProject,
                projects: projects,
                sheetHeight: 240,
                peekHeight: 140,
                pushDown: 0
            )
            .padding(.bottom, safeBottom + 70)
            .padding(.horizontal, 16)
            .opacity(isExpanded || isAdding ? 0 : 1)
            .disabled(isTimerRunning)
            .frame(height: isExpanded || isAdding ? 0 : nil)
            .clipped()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .animation(.spring(response: 0.65, dampingFraction: 0.82), value: isExpanded)
        .animation(.spring(response: 0.65, dampingFraction: 0.82), value: isAdding)
    }
}

#Preview("ContentView") {
    PreviewContainerView()
}

private struct PreviewContainerView: View {
    var body: some View {
        let container = PreviewSamples.makeContainer()
        PreviewSamples.seed(container)
        return ContentView()
            .modelContainer(container)
    }
}
