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
    
    private func deleteProject(at offsets: IndexSet) {
        if let index = offsets.first {
            projectToDelete = projects[index]
            deleteConfirmation = true
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(projects.filter { $0.id != selectedProject?.id }, id: \.id) { project in
                            ProjectRowView(project: project, fontSize: AppTheme.avenirBody, height: AppLayout.rowHeightCompact, cornerRadius: AppLayout.cornerRadiusPill) {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    selectedProject = project
                                }
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    projectToDelete = project
                                    deleteConfirmation = true
                                } label: {
                                    Label(AppStrings.delete, systemImage: "trash")
                                }
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .padding(.vertical, AppLayout.paddingSmall)
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
                title: Text(AppStrings.deleteProject),
                message: Text(AppStrings.deleteProjectMessage),
                primaryButton: .destructive(Text(AppStrings.delete)) {
                    if let projectToDelete = projectToDelete {
                          withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                              modelContext.delete(projectToDelete)
                          }
                      }
                },
                secondaryButton: .cancel {
                    projectToDelete = nil
                }
            )
        }
    }
}

   
    


#Preview("ProjectListView") {
    @Previewable @State var show = true
    @Previewable @State var selectedProject: Project? = nil
    let container = PreviewSamples.makeContainer()

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
