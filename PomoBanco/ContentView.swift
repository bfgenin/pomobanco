import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var projects: [Project]
    
    @State private var focusMode = false
    @State private var selectedProject: Project? = nil
    @State var show = false
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            // BOTTOM:
            ProjectListView(show: $show, selectedProject: $selectedProject, projects: projects)
            
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
                    TimerView(project: selectedProject, focusMode: $focusMode)
                        .zIndex(1)
                        .frame(width: 250, height: 250)
                        .shadow(color: Color.hotPink.opacity(0.9), radius: 50, x: 0, y: 0)
                }
                //.offset(y: show ? -300 : 0)
                
                // ** END: TIMER VIEW
                
                // ** SELECTED PROJECT:
                if let project = selectedProject {
//                    SelectedProjectView(project: project, show: $show)
                } else {
                    Text("select a project")
                        .foregroundStyle(.white)
                        .font(.custom("Avenir", size: 24))
                        .fontWeight(.bold)
                        .opacity(0.20)
                        .matchedGeometryEffect(id: "selected-project", in: namespace)
                        .frame(width: 380, height: 100)
                        .onTapGesture {
                            withAnimation (.spring(response: 0.4, dampingFraction: 0.6)) {
                                show.toggle()
                            }
                        }
           
                }

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
    ContentView()
}

