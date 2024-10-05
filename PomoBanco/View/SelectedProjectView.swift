import SwiftUI
import SwiftData

struct SelectedProjectView: View {
    @Environment(\.modelContext) var modelContext
    
    var project: Project? // keep this optional
    
    @Binding var isExpanded: Bool
    
    // strings
    @State private var details: String
    @State private var name: String
    
    // display for disclosed groups
    @State private var isDescription = true
    @State private var isSubTasks = true
    @State private var isChart = true
    
    @Namespace private var namespace
    
    // no select project / selected: reg. / selecteD: expanded.
    
    init(project: Project?, isExpanded: Binding<Bool>) {
        self.project = project
        self._isExpanded = isExpanded
        self._details = State(initialValue: project?.details ?? "")
        self._name = State(initialValue: project?.name ?? "")
    }
    
    var body: some View {
        ZStack {
            
            if let project = project {
                
                VStack(spacing: 0) {
                    HeaderView(project: project)
                        .frame(width: 380, height: 90)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                isExpanded.toggle()
                            }
                        }
                    
                    if isExpanded {
                       ExpandedView(project: project)
                            .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                    }
                }
          
            } else {
                    Text("select a project")
                        .foregroundStyle(.white)
                        .font(.custom("Avenir", size: 24))
                        .fontWeight(.bold)
                        .opacity(0.20)
                        .matchedGeometryEffect(id: "selected-project", in: namespace)
                        .frame(width: 380, height: 100)
                    
                }
            }
        }
    
    private func addNewTask() {
        let task1 = Task(title: "hello, I'm a cute task.", complete: false)
        
        guard let project = project else { return }
        project.addTask(task1)
        do {
            try modelContext.save() // Ensure you save changes to the model context
        } catch {
            print("Failed to save entry: \(error.localizedDescription)")
        }
    }
    
    private func HeaderView(project: Project) -> some View {
        HStack {
            if let tag = project.tag  {
                Text(tag)
                    .padding(.leading, 15)
                    .frame(width: 85, height: 28, alignment: .leading)
                    .background(.red)
                    .clipShape(.capsule)
                    .font(.custom("Avenir", size: 24))
                    .matchedGeometryEffect(id: "project-tag", in: namespace)
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
    }
    
    private func ExpandedView(project: Project) -> some View {
        VStack {
            DisclosureGroup("       DESCRIPTION", isExpanded: $isDescription) {
                VStack(alignment: .leading) {
                    TextEditor(text: $details)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 15)
                        .frame(maxHeight: 158)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                                .frame(width: 345, height: 158)
                        )
                }
                .frame(width: 350, height: 170)
            }
            
            
            DisclosureGroup("       TASKS", isExpanded: $isSubTasks) {
                ScrollView {
                    ForEach(project.tasks, id: \.id) { task in
                        Text(task.title)
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        .frame(width: 345, height: 112)
                )
                .frame(width: 350, height: 112)
            }
            
            DisclosureGroup("       CHART", isExpanded: $isChart) {
                VStack(alignment: .leading) {
                    Text("Hello")
                        .padding(.horizontal, 15)
                        .frame(maxHeight: 158)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                                .frame(width: 345, height: 190)
                        )
                }
                .frame(width: 350, height: 190)
            }
            
            Text("Created: \(DateFormatter.localizedString(from: project.startDate, dateStyle: .long, timeStyle: .short))")
                .font(.custom("Avenir", size: 10))
        }
        .foregroundStyle(.white)
        .font(.custom("Avenir", size: 16))
        .ignoresSafeArea()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)
        
        var project1 = Project(
            name: "name 1",
            details: "Sample project details that go on for a while.",
            startDate: .now,
            tasks: [],
            entries: []
        )
        
        var show = false
        
        let showBinding = Binding<Bool>(
            get: { show },
            set: { show = $0 }
        )
        
        return SelectedProjectView(project: project1, isExpanded: showBinding)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
