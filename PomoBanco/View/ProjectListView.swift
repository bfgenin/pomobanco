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
    
            VStack {
                
                HStack{
                    Button("     +     ") {
                        withAnimation(){
                            addProject.toggle()
                        }
                        
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .stroke(lineWidth: 1)
                    )
                    .foregroundStyle(.white)
                    .padding(.leading, 10)
                    .frame(width: 100, alignment: .leading)
                    
                    Spacer()
                        .frame(width: 150)
                    
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
            
                
                List {
                    if addProject {
                        AddNewProject(addProject: $addProject)
                            .listRowBackground(Color.clear)
                            .padding(.bottom, 20)
                            
                    }
                     
                    ForEach(projects, id: \.self) { project in
                        ReducedProjectView(project: project, selectedProject: $selectedProject)
                            .listRowBackground(Color.clear)
                           
                    }
                    .onDelete(perform: deleteProject)
                }
                .frame(width: 380)
                .matchedGeometryEffect(id: "list-section", in: namespace)
                .listStyle(PlainListStyle())
            
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
                Text(tag)
                    .padding(.leading, 10)
                    .frame(width: 60, height: 20, alignment: .leading)
                    .background(Color.red.opacity(0.8))
                    .clipShape(.capsule)
                    .padding(.leading, 10)
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
        .onAppear {
            withAnimation(.easeIn(duration: 4)) { // Apply custom animation on appear
                isAnimating = true
            }
        }
        .frame(width: 333, height: 40)
        .font(.custom("Avenir", size: 16))
        .foregroundStyle(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                .frame(width: 350, height: 40)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                selectedProject = project
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)
        
        let project1 = Project(id: UUID(), name: "name 1", details: "test one", startDate: .now, tasks: [], entries: [])
        let project2 = Project(id: UUID(), name: "name 2", details: "test two", startDate: .now, tasks: [], entries: [])
        let project3 = Project(id: UUID(), name: "name 3", details: "test 3", startDate: .now, tasks: [], entries: [])
        
        let projects = [project1, project2, project3]

        // State variables for the preview
        @State var show = false
        @State var selectedProject: Project? = nil
        
        return ProjectListView(bottomShow: $show, selectedProject: $selectedProject, projects: projects)
            .modelContainer(container)
        
    } catch {
        return AnyView(Text("Failed to create preview: \(error.localizedDescription)"))
    }
}
