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
    
    @Binding var show: Bool
    @Binding var selectedProject: Project?
    
    var projects: [Project]
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 35)
                .fill(LinearGradient(gradient: Gradient(stops: [
                    .init(color: .darkPink, location: 0.0),
                    .init(color: .medPink, location: 0.8),
                    .init(color: .lightPink, location: 0.9)
                ]),
                                     startPoint: .top,
                                     endPoint: .bottom)
                )
                .frame(height: 354)
                .shadow(color: Color.hotPink.opacity(0.8), radius: 20, x: 0, y: -15)
                .matchedGeometryEffect(id: "blue-section", in: namespace)
                .offset(y: show ? 500 : 300)
            
            List {
                ForEach(projects, id: \.self) { project in
                    ReducedProjectView(project: project, selectedProject: $selectedProject)
                        .listRowBackground(Color.clear)
                }
            }
            .frame(maxWidth: 350, maxHeight: 354)
            .matchedGeometryEffect(id: "list-section", in: namespace)
            .listStyle(PlainListStyle())
            .offset(y: show ? 520 : 320)
            .blur(radius: show ? 1 : 0)
        }
    }
}


    
struct ReducedProjectView: View {
    var project: Project
    @Binding var selectedProject: Project?
    
    var body: some View {
        HStack {
            //
            ZStack {
                Circle()
                    .fill(Color.hotPink.opacity(0.5))
                    .frame(width: 11, height: 11)
                
                Circle()
                    .stroke(Color.white, lineWidth: 1)
                    .frame(width: 10, height: 10)
            }
            .padding(.leading, 11)
            
            Text(project.tag ?? "")
                .padding(.horizontal, 5)
                .frame(maxWidth: 80, alignment: .leading)
            
            Text(project.name)
                .truncationMode(.tail)
                .frame(maxWidth: 150, alignment: .leading)
            Spacer()
            Text(project.formatTime(for: .now))
                .padding(.trailing)
            
        }
        
        .frame(width: 333, height: 40)
        .font(.custom("Avenir", size: 16))
        .foregroundStyle(.white)
        .border(.white, width: 1.5)
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
        
        return ProjectListView(show: $show, selectedProject: $selectedProject, projects: projects)
            .modelContainer(container)
        
    } catch {
        return AnyView(Text("Failed to create preview: \(error.localizedDescription)"))
    }
}
