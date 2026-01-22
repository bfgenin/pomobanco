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
                            ReducedProjectView(project: project, selectedProject: $selectedProject)
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


    
struct ReducedProjectView: View {
    var project: Project
    @Binding var selectedProject: Project?
    @State private var isAnimating = false
    
    var body: some View {
        HStack {
            if let tag = project.tag {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.from(name: tag.color))
            
            } else {
                Text("")
                    .frame(width: 60, height: 20, alignment: .leading)
                    .frame(height: 20, alignment: .leading)
                    .padding(.leading, 10)
            }
            Text(project.name)
                .truncationMode(.tail)
                .frame(maxWidth: 150, alignment: .leading)
            Spacer()
            Text(project.formatTime(for: .now))
                .padding(.trailing)
        
        }
     
//        .onAppear {
//            withAnimation(.easeIn(duration: 4)) {
//                isAnimating = true
//            }
//        }
        .frame(width: 333, height: 40)
        .font(.custom("Avenir", size: 16))
        .foregroundStyle(.white)
        .background(
            .ultraThinMaterial.opacity(0.2), in: RoundedRectangle(cornerRadius: 25, style: .continuous)
          
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.25)) {
                selectedProject = project
            }
        }

    }
}

private func createSampleProject() -> Project {
    let project = Project(
        id: UUID(),
        name: "Sample Project",
        details: "A project with sample entries for chart preview",
        complete: false,
        startDate: .now,
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

#Preview {
    @Previewable @State var show = false
    @Previewable @State var selectedProject: Project? = nil
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, Tag.self, configurations: config)
        
        let tag = Tag(name: "health", color: "blue")
        let tag2 = Tag(name: "work", color: "red")
        
        
        let project1 = Project(id: UUID(), name: "name 1", details: "test one", startDate: .now, tag: tag, entries: [])
        let project2 = Project(id: UUID(), name: "name 2", details: "test two", startDate: .now, tag: tag2, entries: [])
        let project3 = Project(id: UUID(), name: "name 3", details: "test 3", startDate: .now,  tag: tag, entries: [])
        
        let projects = [project1, project2, project3]
      
        
        return ProjectListView(bottomShow: $show, selectedProject: $selectedProject, projects: projects)
            .modelContainer(container)
        
    } catch {
        return AnyView(Text("Failed to create preview: \(error.localizedDescription)"))
    }
}
