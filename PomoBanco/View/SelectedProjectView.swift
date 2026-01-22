import SwiftUI
import SwiftData

struct SelectedProjectView: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var selectedProject: Project?
    @Binding var isExpanded: Bool
    
    // strings
    @State private var details: String = ""
    @State private var name: String = ""
    
    // display for disclosed groups
    @State private var isDescription = true
    @State private var isSubTasks = true
    @State private var isChart = true
    
    @Namespace private var namespace
    
    // no select project / selected: reg. / selected: expanded.
    //
    //    init(selectedProject: Binding<Project?>, isExpanded: Binding<Bool>) {
    //        self.project = project
    //        self._isExpanded = isExpanded
    //        self._details = State(initialValue: project?.details ?? "")
    //        self._name = State(initialValue: project?.name ?? "")
    //    }
    //
    var body: some View {
        
        if let selectedProject = selectedProject {
            
            VStack(alignment: .center, spacing: 0) {
                HeaderView(project: selectedProject)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            isExpanded.toggle()
                        }
                    }
                    .frame(height: 70)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < -100 {
                                    withAnimation {
                                        deselectProject()
                                    }
                                }
                            }
                    )
                
                if isExpanded {
                    ExpandedView(project: selectedProject)
                        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                        
                }
            }
            .background(.darkPink)
            
        } else {
            Text("select a project")
                .foregroundStyle(.white)
                .font(.custom("Avenir", size: 24))
                .fontWeight(.bold)
                .opacity(0.20)
                .matchedGeometryEffect(id: "selected-project", in: namespace)
                .background(
                    .ultraThinMaterial.opacity(0.2), in: RoundedRectangle(cornerRadius: 25, style: .continuous)
                 )
//                .background(.darkPink)
//            
            
        }
    }
    
    private func deselectProject() {
        // Reset the project state to deselect the project
        selectedProject = nil
        isExpanded = false
        details = ""
        name = ""
    }
    
    private func HeaderView(project: Project) -> some View {
        HStack {
            if let tag = project.tag  {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.from(name: tag.color))
                
                
            } else {
                Text("")
                    .padding(.leading, 10)
                    .frame(width: 85, height: 28, alignment: .leading)
            }
            
            Text(project.name)
                .truncationMode(.tail)
                .padding(.leading, 5)
                .frame(maxWidth: 270, alignment: .center)
                .fontWeight(.bold)
                .matchedGeometryEffect(id: "project-name", in: namespace)
            
            Spacer()
            
            Text(project.formatTime(for: .now))
                .padding(.leading, 10)
                .matchedGeometryEffect(id: "project-time", in: namespace)
        }
        .foregroundStyle(.white)
        .font(.custom("Avenir", size: 24))
        .background(
            .ultraThinMaterial.opacity(0.2), in: RoundedRectangle(cornerRadius: 25, style: .continuous)
          
        )
    }
    
    private func ExpandedView(project: Project) -> some View {
        VStack(alignment: .leading, spacing: 5){
           
            if let tag = project.tag  {
                Text(tag.name)
            }
            
            Text("DESCRIPTION")
                
            TextField("add description here", text: $details)
                .wrappedTextFieldStyle(rectangleWidth: 345, rectangleHeight: 181)
            
            Text("CHART")
            if (selectedProject != nil) {
                ChartView(project: project)
                    .wrappedTextFieldStyle(rectangleWidth: 345, rectangleHeight: 300)
            }
                
            
//            Text("View Place Holder")
//                .wrappedTextFieldStyle(rectangleWidth: 345, rectangleHeight: 181)
             
            Text("Created: \(DateFormatter.localizedString(from: project.startDate, dateStyle: .long, timeStyle: .short))")
                .font(.custom("Avenir", size: 12))
        }
        .foregroundStyle(.white)
        .font(.custom("Avenir", size: 16))
    }
}

#Preview("SelectedProjectView") {
    @Previewable @State var isExpanded = false
    @Previewable @State var selectedProject: Project? = nil

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Project.self, configurations: config)

    let sampleProject = createSampleProject()

    SelectedProjectView(selectedProject: $selectedProject, isExpanded: $isExpanded)
        .modelContainer(container)
        .task {
            container.mainContext.insert(sampleProject)
            selectedProject = sampleProject
            // try? container.mainContext.save() // optional
        }
}


private func createSampleProject() -> Project {
    let tag = Tag(
        name: "sample",
        color:"#FF6B3B"
        )
    
    let project = Project(
        id: UUID(),
        name: "Sample Project",
        details: "A project with sample entries for chart preview",
        complete: false,
        startDate: .now,
        tag: tag,
        endDate: nil,
        entries: []
    )

    let calendar = Calendar.current
    let sampleEntries = [
        Entry(date: .now, duration: 10005),
        Entry(date: .now, duration: 10005),
        Entry(date: calendar.date(byAdding: .day, value: -1, to: .now) ?? .now, duration: 1000),
        Entry(date: calendar.date(byAdding: .day, value: -1, to: .now) ?? .now, duration: 1.0),
        Entry(date: calendar.date(byAdding: .day, value: -2, to: .now) ?? .now, duration: 3.0),
        Entry(date: calendar.date(byAdding: .day, value: -3, to: .now) ?? .now, duration: 2.5),
        Entry(date: calendar.date(byAdding: .day, value: -4, to: .now) ?? .now, duration: 1.5)
    ]

    project.entries = sampleEntries
    return project
}
