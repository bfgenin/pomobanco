import SwiftUI
import SwiftData

// MARK: - Preference Keys (ANCHOR-BASED)
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

    // STATE
    @State private var selectedProject: Project? = nil
    @State private var isExpanded = false
    @State private var bottomShow = false
    @State private var topShow = false
    @State private var isTimerRunning = false
    @State private var focusMode = false

    // DEBUG
    @State private var showDebugFrames = true

    // TIMER MEASUREMENT RESULT
    @State private var timerBottomY: CGFloat = 0

    // DEBUG RECT DRAWER
    private func debugRect(_ rect: CGRect, color: Color, label: String) -> some View {
        ZStack(alignment: .topLeading) {
            Rectangle().stroke(color, lineWidth: 2)
            Text(label)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(color)
                .padding(6)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                .padding(6)
        }
        .frame(width: rect.width, height: rect.height)
        .position(x: rect.midX, y: rect.midY)
        .allowsHitTesting(false)
    }

    var body: some View {
        GeometryReader { geo in
            let safeTop = geo.safeAreaInsets.top
            let safeBottom = geo.safeAreaInsets.bottom
            let screenH = geo.size.height
            let screenW = geo.size.width

            // TIMER
            let timerSize = min(280, screenW * 0.62)
            let timerTopPadding: CGFloat = 12
            let timerLift: CGFloat = -60
            let timerGap: CGFloat = 12

            // PROJECT LIST
            let sheetHeight = min(600, screenH * 0.20)
            let sheetPeek = max(110, screenH * 0.14)
            let sheetPushDown = isExpanded ? min(420, screenH * 0.32) : 0

            // SELECTED PROJECT
            let selectedWidth = min(380, screenW * 0.92)
            let collapsedHeight: CGFloat = 72

            // Fallback timer bottom until anchor resolves
            let fallbackTimerBottom = safeTop + timerTopPadding + timerSize
            let effectiveTimerBottom = timerBottomY == 0 ? fallbackTimerBottom : timerBottomY

            // This is the hard rule:
            // SelectedProject ALWAYS starts here (collapsed + expanded)
            let selectedTopY: CGFloat = effectiveTimerBottom + timerGap
     
            // SelectedProject can use ALL space below that
            let raw = screenH - selectedTopY + 80
            let selectedMaxHeight = max(collapsedHeight, raw)



            ZStack {
                BlurBackground().ignoresSafeArea()

                // MARK: - SELECTED PROJECT (TOP-ANCHORED, DOWNWARD GROWTH)
                VStack(spacing: 0) {
                    Spacer().frame(height: selectedTopY)

                    SelectedProjectView(
                        selectedProject: $selectedProject,
                        isExpanded: $isExpanded,
                        maxExpandedHeight: selectedMaxHeight,
                        collapsedHeight: collapsedHeight
                    )
                    .frame(width: selectedWidth)
                    .frame(height: isExpanded ? selectedMaxHeight : collapsedHeight, alignment: .top)
                  //  .clipped()
                    .anchorPreference(key: SelectedProjectBoundsKey.self, value: .bounds) { $0 }
                }
                .blur(radius: topShow ? 10 : 0)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .zIndex(5)
                .onChange(of: isExpanded) { _, _ in
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                        bottomShow = false
                    }
                }

                // MARK: - PROJECT LIST (BOTTOM SHEET)
                VStack(spacing: 0) {
                    Spacer()

                    ProjectListView(
                        bottomShow: $bottomShow,
                        selectedProject: $selectedProject,
                        projects: projects,
                        sheetHeight: sheetHeight,
                        peekHeight: sheetPeek,
                        pushDown: sheetPushDown
                    )
                    .padding(.bottom, safeBottom + 70)
                    .anchorPreference(key: ProjectListBoundsKey.self, value: .bounds) { $0 }
                }
                .blur(radius: topShow ? 10 : 0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .allowsHitTesting(!isTimerRunning)
                .opacity(isTimerRunning ? 0.35 : 1)
                .blur(radius: isTimerRunning ? 4 : 0)
                .zIndex(2)

                // MARK: - TIMER (ANCHOR-MEASURED)
                VStack {
                    TimerView(
                        isTimerRunning: $isTimerRunning,
                        project: selectedProject,
                        focusMode: $focusMode
                    )
                    .frame(width: timerSize, height: timerSize)
                    .anchorPreference(key: TimerBoundsKey.self, value: .bounds) { $0 }
                    .shadow(
                        color: (focusMode ? Color.hotPink : .hotPink).opacity(0.9),
                        radius: 50, x: 2, y: 1
                    )
                    .padding(.top, timerTopPadding)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                            topShow.toggle()
                        }
                    }

               
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .offset(y: topShow ? -timerLift : 0)
                .zIndex(10)
            }

            // MARK: - TIMER RESOLUTION + DEBUG
            .overlayPreferenceValue(TimerBoundsKey.self) { anchor in
                GeometryReader { proxy in
                    if let anchor {
                        let rect = proxy[anchor]
                        Color.clear
                            .onAppear { timerBottomY = rect.maxY }
                            .onChange(of: rect.maxY) { timerBottomY = $0 }

                        if showDebugFrames {
                            debugRect(
                                rect,
                                color: .cyan,
                                label: "TIMER\n\(Int(rect.minY))→\(Int(rect.maxY))"
                            )
                        }

                        if showDebugFrames {
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: rect.maxY + timerGap))
                                path.addLine(to: CGPoint(x: proxy.size.width, y: rect.maxY + timerGap))
                            }
                            .stroke(.orange, style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                        }
                    }
                }
            }

            // MARK: - SELECTED PROJECT DEBUG (YELLOW)
            .overlayPreferenceValue(SelectedProjectBoundsKey.self) { anchor in
                GeometryReader { proxy in
                    if showDebugFrames, let anchor {
                        let rect = proxy[anchor]
                        debugRect(
                            rect,
                            color: .yellow,
                            label: "SELECTED\nh:\(Int(rect.height))"
                        )
                    }
                }
            }

            // MARK: - PROJECT LIST DEBUG (GREEN)
            .overlayPreferenceValue(ProjectListBoundsKey.self) { anchor in
                GeometryReader { proxy in
                    if showDebugFrames, let anchor {
                        let rect = proxy[anchor]
                        debugRect(
                            rect,
                            color: .green,
                            label: "PROJECT LIST\nh:\(Int(rect.height))"
                        )
                    }
                }
            }
            .ignoresSafeArea()
            .onTapGesture(count: 2) { showDebugFrames.toggle() }
        }
    }
}


#Preview("ContentView") {
    let container = PreviewSamples.makeContainer()
    PreviewSamples.seed(container)

    return ContentView()
        .modelContainer(container)
}
