import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var projects: [Project]
    
    @State private var focusMode = false
    @State private var selectedProject: Project? = nil
    @State var bottomShow = false
    @State var topShow = false
    @State var isExpanded = false
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            // ** MIDDLE SECTION
            
            SelectedProjectView(project: selectedProject, isExpanded: $isExpanded)
                .onChange(of: isExpanded) { oldValue, newValue in
//                    if newValue == false {
//                        withAnimation {
//                            topShow = false
//                            bottomShow = false
//                        }
//                    } else if newValue == true {
//                        withAnimation {
//                            topShow = true
//                            bottomShow = true
//                        }
//                    }
                }
                .blur(radius: !topShow && isExpanded ? 10 : 0)
                .offset(y: isExpanded ? 0 : 50)
            // BOTTOM:
            ProjectListView(bottomShow: $bottomShow, selectedProject: $selectedProject, projects: projects)
               // .offset(y: bottomShow ? 500 : 300)
            // TOP:
            VStack {
    
                // ** TIMER VIEW
                ZStack {
                    // Orange rectangle
                    RoundedRectangle(cornerRadius: 50, style: .continuous)
                        .fill(.lightPink)
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
                        .shadow(color: Color.hotPink.opacity(0.9), radius: 50, x: 0, y: 0)
                }
                .blur(radius: topShow ? 0.4 : 0)
                .offset(y: topShow ? -340 : 0)
                
                // ** END: TIMER VIEW
                
                // ** SELECTED PROJECT:
               

                // STYLING
                Spacer()
                
                // NAVIGATION BAR:
//                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
//                    .fill(.lightPink)
//                    .frame(width: 354, height: 42)
//                    .opacity(1)
//                    .offset(y: -12)
            }
            //** END ZSTACK
        }
//        .sheet(isPresented: $show) {
//            AddProjectView()
//            .presentationDetents([.height(500)])
//        }
        .background(
            LinearGradient(gradient: Gradient(stops: [
                .init(color: .darkPink, location: 0.5),
                .init(color: .hotPink, location: 0.7)
            ]),
                           startPoint: .top,
                           endPoint: .bottom)
            
        )
        .ignoresSafeArea()
        
    }
}


struct AddProjectView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var name = ""
    @State var details = ""
    var body: some View {
        VStack {
            TextField("Enter title.", text: $name)
                .frame(width: 300, height: 50)
                .border(.blue)
            TextField("Details.", text: $details)
                .frame(width: 300, height: 50)
                .border(.blue)
            
            Button("save", action: saveProject)
                .frame(width: 60, height: 30)
                .foregroundStyle(.white)
                .background(.blue)
                .clipShape(.capsule)
        }
    }
    
    func saveProject() {
        let project = Project(name: name, details: details, startDate: .now, tasks: [Task](), entries: [Entry]())
        modelContext.insert(project)
        dismiss()
    }
}

#Preview {
    do {
        // Create a model configuration for in-memory storage
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)
        
        // Create a sample project
        let sampleProject = Project(
            name: "Sample Project",
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


