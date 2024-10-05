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
            
            
            RoundedRectangle(cornerRadius: 35)
                .fill(LinearGradient(gradient: Gradient(stops: [
                    .init(color: .darkPink, location: 0.34),
                    .init(color: .medPink, location: 0.7),
                    .init(color: .lightPink, location: 0.9)
                ]),
                                     startPoint: .top,
                                     endPoint: .bottom)
                )
                .frame(height: 354)
                .shadow(color: Color.hotPink.opacity(0.8), radius: 20, x: 0, y: -15)
                .matchedGeometryEffect(id: "blue-section", in: namespace)
                .offset(y: bottomShow ? 500 : 300)
            
            VStack {
                
                HStack{
                    Button("Add Project") {
                        withAnimation(){
                            addProject.toggle()
                        }
                        
                    }
                    .foregroundStyle(.white)
                    .frame(width: 100, alignment: .leading)
                    
                    Spacer()
                    
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
                            .padding(.bottom)
                    }
                    ForEach(projects, id: \.self) { project in
                        ReducedProjectView(project: project, selectedProject: $selectedProject)
                            .listRowBackground(Color.clear)
                           
                    }
                    .onDelete(perform: deleteProject)
                }
             
                .disabled(bottomShow)
                .frame(width: 380)
                .matchedGeometryEffect(id: "list-section", in: namespace)
                .listStyle(PlainListStyle())
            }
            .frame(width: 390, height: 400)
            .offset(y: bottomShow ? 530 : 330)
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
                .fill(Color.white.opacity(0.08))
                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                .frame(width: 350, height: 40)
        )
       // .border(.white, width: 1.5)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {

                selectedProject = project
                
            }
        }
        .onLongPressGesture {
            // enter edit mode
            
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)
        
        let project1 = Project(name: "name 1", details: "test one", startDate: .now, tasks: [], entries: [])
        let project2 = Project(name: "name 2", details: "test two", startDate: .now, tasks: [], entries: [])
        let project3 = Project(name: "name 3", details: "test 3", startDate: .now, tasks: [], entries: [])
        
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
