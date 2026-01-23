//
//  ProjectView.swift
//  PomoBanco
//
//  Created by Belish Genin on 10/2/24.
//

import SwiftUI
import SwiftData

struct ProjectListView: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var bottomShow: Bool
    @Binding var selectedProject: Project?
    
    var projects: [Project]
    
    @State var projectToDelete: Project? = nil
    @State var addProject = false
    @State var deleteConfirmation = false
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
//            Color.darkBlue
//                .ignoresSafeArea()
            
            VStack {
   

                
                HStack{
                    
                    RoundedRectangle(cornerRadius: 40)
                        .fill(.lightPink)
                        .contentShape(Rectangle())
                        .frame(width: 80, height: 10)
                        .opacity(0.5)
                        .onTapGesture {
                            withAnimation() {
                                bottomShow.toggle()
                            }
                        }
                     
                }
            
                
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
            
            .frame(width: 390, height: 500)
            .offset(y: bottomShow ? 530 : 430)
            .blur(radius: bottomShow ? 1 : 0)
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
    
    private func deleteProject(at offsets: IndexSet) {
        if let index = offsets.first {
            projectToDelete = projects[index]
            deleteConfirmation = true
        }
    }
    
    
}



#Preview {
    @Previewable @State var show = false
    @Previewable @State var selectedProject: Project? = nil
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, Tag.self, configurations: config)
       
      
        
        return ProjectListView(bottomShow: $show, selectedProject: $selectedProject, projects: PreviewSamples.sampleProjects())
            .modelContainer(container)
        
    } catch {
        return AnyView(Text("Failed to create preview: \(error.localizedDescription)"))
    }
}
