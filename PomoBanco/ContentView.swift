import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var projects: [Project]
    
    @State private var focusMode = false
    @State private var selectedProject: Project? = nil
    @State private var isTimerRunning = false
    
    @State var isExpandedNew = false
    @State var maxShow = false
    @State var bottomShow = false // ProjectListView Visible
    @State var topShow = false // Timer Visible
    @State var isExpanded = false // Expanded project
    
    @Namespace var namespace
    
    // Constants for dimensions and offsets
    private enum Constants {
        static let backgroundHeight: CGFloat = 410
        static let timerViewSize: CGFloat = 250
        static let sectionHeight: CGFloat = 300
        static let topOffsetExpanded: CGFloat = -50
        static let bottomOffsetExpanded: CGFloat = 30
        static let bottomShowOffset: CGFloat = 500
        static let baseOffset: CGFloat = 250
        static let shadowRadius: CGFloat = 50
        static let projectWidth: CGFloat = 360
    }

    var body: some View {
        ZStack {
            // ** SECTION
            
            // LARGE BACKGROUND GRADIENT
            BlurBackground()
                .ignoresSafeArea()
    
            
            SelectedProjectView(selectedProject: $selectedProject, isExpanded: $isExpanded)
                .frame(width: Constants.projectWidth, height: 150)
                .onChange(of: isExpanded) { oldValue, newValue in
                    withAnimation {
                        topShow = newValue
                        bottomShow = newValue
                    }
                }
                .blur(radius: !topShow && isExpanded ? 10 : 0)
                .offset(y: isExpanded ? 0 : -50)
                .foregroundStyle(.ultraThinMaterial)
            
          //  AddNewProject()
            
            TimerView(isTimerRunning: $isTimerRunning, project: selectedProject, focusMode: $focusMode)
                .onTapGesture {
                    withAnimation {
                        topShow.toggle()
                    }
                }
                .zIndex(1)
           
                .frame(width: Constants.timerViewSize, height: Constants.timerViewSize)
                .shadow(color: focusMode ? Color.hotPurple.opacity(0.9) : Color.hotPink.opacity(0.9), radius: Constants.shadowRadius, x: 2, y: 1)
                .blur(radius: topShow ? 0.4 : 0)
                .offset(y: topShow ? -Constants.bottomShowOffset : -Constants.baseOffset)
            
       
            VStack(spacing: 0) {
                
             //   AddNewProject(isExpanded: $isExpanded)
                // currently addProject is a top vi
                ProjectListView(bottomShow: $bottomShow, selectedProject: $selectedProject, projects: projects)
                    .allowsHitTesting(!isTimerRunning)
                    
                

            }
            .blur(radius: isTimerRunning ? 4 : 0)
            .opacity(isTimerRunning ? 0.35 : 1)
            .animation(.easeInOut(duration: 0.2), value: isTimerRunning)
            .allowsHitTesting(!isTimerRunning)
            .offset(y: bottomShow ? 100 : 0)
            
           // ** END Z-STACK
        }
        .ignoresSafeArea()
    }
}
    

#Preview("ContentView") {
        let container = PreviewSamples.makeContainer()
        PreviewSamples.seed(container)

        return ContentView()
            .modelContainer(container)
    
}
