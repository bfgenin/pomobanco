import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var projects: [Project]
    
    @State private var focusMode = false
    @State private var selectedProject: Project? = nil
    
    @State var maxShow = false
    @State var bottomShow = false
    @State var topShow = false
    @State var isExpanded = false
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            // ** SECTION
        
            // LARGE BACKGROUND GRAIDENT
            if !focusMode {
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: .darkPink, location: 0.5),
                    .init(color: .hotPink, location: 0.7)
                ]),
                               startPoint: .top,
                               endPoint: .bottom)
            } else {
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: .darkBlue, location: 0.5),
                    .init(color: .hotPurple, location: 0.7)
                ]),
                               startPoint: .top,
                               endPoint: .bottom)
            }

            SelectedProjectView(project: selectedProject, isExpanded: $isExpanded)
                .onChange(of: isExpanded) { oldValue, newValue in
                    if newValue == false {
                        withAnimation {
                            topShow = false
                            bottomShow = false
                        }
                    } else if newValue == true {
                        withAnimation {
                            topShow = true
                            bottomShow = true
                        }
                    }
                }
                .blur(radius: !topShow && isExpanded ? 10 : 0)
                .offset(y: isExpanded ? -50 : 30)
      
            
        
            ZStack {
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .fill(focusMode ? .lightBlue : .lightPink)
                    .frame(height: 410)
                    .opacity(0.4)
                    .shadow(color: Color.lightPink.opacity(0.9), radius: 50, x: 0, y: 2)
                    .onTapGesture {
                        withAnimation {
                            topShow.toggle()
                        }
                    }
                   
                
                TimerView(project: selectedProject, focusMode: $focusMode)
                    .zIndex(1)
                    .frame(width: 250, height: 250)
                    .shadow(color: focusMode ?
                                Color.hotPurple.opacity(0.9) :  Color.hotPink.opacity(0.9),
                                radius: 50, x: 0, y: 0)
                    .blur(radius: topShow ? 0.4 : 0)
               
            }
            .offset(y: topShow ? -550 : -230)
            
            ZStack {
                if !focusMode {
                    RoundedRectangle(cornerRadius: 35)
                        .fill(LinearGradient(gradient: Gradient(stops: [
                            .init(color: .darkPink, location: 0.5),
                            .init(color: .lightPink, location: 1)
                        ]),
                                             startPoint: .top,
                                             endPoint: .bottom)
                        )
                        .frame(height: 300)
                        .shadow(color: Color.hotPink.opacity(0.8), radius: 20, x: 0, y: -15)
                        .matchedGeometryEffect(id: "blue-section", in: namespace)
                        .offset(y: bottomShow ? 400 : 300)
                } else {
                    RoundedRectangle(cornerRadius: 35)
                        .fill(LinearGradient(gradient: Gradient(stops: [
                            .init(color: .darkBlue, location: 0.5),
                            .init(color: .lightBlue, location: 1)
                        ]),
                                             startPoint: .top,
                                             endPoint: .bottom)
                        )
                        .frame(height: 300)
                        .shadow(color: Color.hotPurple.opacity(0.8), radius: 20, x: 0, y: -15)
                        .matchedGeometryEffect(id: "blue-section", in: namespace)
                        .offset(y: bottomShow ? 400 : 300)
                    
                }
                
                ProjectListView(bottomShow: $bottomShow, selectedProject: $selectedProject, projects: projects)
            }
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
            tasks: [],
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
        
        // create a Binding for showing the project view
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


