import SwiftUI
import SwiftData

struct ProjectListView: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var bottomShow: Bool
    @Binding var selectedProject: Project?
    
    var projects: [Project]
    
    // geometry-driven sizing from parent
    let sheetHeight: CGFloat
    let peekHeight: CGFloat
    let pushDown: CGFloat
    
    @State var projectToDelete: Project? = nil
    @State var deleteConfirmation = false
    @State var isExpanded = false
    
    var body: some View {
        VStack {
            VStack {
                
                ScrollView {
                    
                    
                    
                    LazyVStack(spacing: 10) {
                        ForEach(projects.filter { $0.id != selectedProject?.id }, id: \.id) { project in
                            ProjectRowView(project: project, fontSize: 16, height: 40, cornerRadius: 25) {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    selectedProject = project
                                }
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .padding(.vertical, 8)
                }
                .animation(.easeInOut(duration: 0.25), value: selectedProject?.id)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: sheetHeight)
        .frame(maxWidth: .infinity)
        
        
        .offset(y: (bottomShow ? 0 : (sheetHeight - peekHeight)) + pushDown)
        .animation(.spring(response: 0.55, dampingFraction: 0.85), value: bottomShow)
        .animation(.spring(response: 0.55, dampingFraction: 0.85), value: pushDown)
        .alert(isPresented: $deleteConfirmation) {
            Alert(
                title: Text("Delete Project"),
                message: Text("Are you sure you want to delete this project? "),
                primaryButton: .destructive(Text("Delete")) {
                    if let projectToDelete = projectToDelete {
                        modelContext.delete(projectToDelete)
                    }
                },
                secondaryButton: .cancel {
                    projectToDelete = nil
                }
            )
        }
    }
}

//    private func deleteProject(at offsets: IndexSet) {
//        if let index = offsets.first {
//            projectToDelete = projects[index]
//            deleteConfirmation = true
//        }
//    }
    


#Preview("ProjectListView") {
    @Previewable @State var show = true
    @Previewable @State var selectedProject: Project? = nil

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Project.self, Tag.self, configurations: config)

    return ProjectListView(
        bottomShow: $show,
        selectedProject: $selectedProject,
        projects: PreviewSamples.sampleProjects(),
        sheetHeight: 520,
        peekHeight: 120,
        pushDown: 0
    )
    .background(Color.darkBlue)
    .frame(height: 700)
    .padding()
    .modelContainer(container)
}
