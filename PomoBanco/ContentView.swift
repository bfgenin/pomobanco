import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var projects: [Project]
    
    @State private var focusMode = false
    @State private var selectedProject: Project? = nil
    @State private var isTimerRunning = false
    
    @State var maxShow = false
    @State var bottomShow = false
    @State var topShow = false
    @State var isExpanded = false
    
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
            
            VStack {    
                
                ProjectListView(bottomShow: $bottomShow, selectedProject: $selectedProject, projects: projects)
                    .allowsHitTesting(!isTimerRunning)
                    
                AddNewProject()
                    .allowsHitTesting(!isTimerRunning)
            }
            .blur(radius: isTimerRunning ? 4 : 0)
            .opacity(isTimerRunning ? 0.35 : 1)
            .animation(.easeInOut(duration: 0.2), value: isTimerRunning)
            .allowsHitTesting(!isTimerRunning)
            .offset(y: bottomShow ? 20 : 0)
            //** END Z-STACK
        }
        .ignoresSafeArea()
    }
}

#Preview {
    do {
        // Create a model configuration for in-memory storage
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)
        
        // Create a sample project
        let sampleProject = Project(
            id: UUID(), name: "Sample Project",
            details: "This is a sample project for preview purposes.",
            startDate: .now,
            entries: []
        )
        
        // Insert the sample project into the context
        let modelContext = container.mainContext
        modelContext.insert(sampleProject)
        
        // Create a Binding for the selected project
        var selectedProject: Project? = sampleProject
        let selectedProjectBinding = Binding<Project?>(
            get: { selectedProject },
            set: { selectedProject = $0 }
        )
        
        // Create a Binding for showing the project view
        var show = false
        let showBinding = Binding<Bool>(
            get: { show },
            set: { show = $0 }
        )
        
        // Return the ContentView with the model container
        return ContentView()
            .modelContainer(container)
            .environment(\.modelContext, modelContext)
         
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
