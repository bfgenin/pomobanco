//
//  SelectedProjectView.swift
//  PomoBanco
//
//  Created by Belish Genin on 10/2/24.
//

import SwiftUI
import SwiftData

struct SelectedProjectView: View {
    @Binding var project: Project
    @Binding var show: Bool
    
    @State var IsEdited = true
    
    @Namespace var namespace
    
    var body: some View {
        VStack {
            HStack {
                Text(project.tag ?? "")
                    .padding(.leading, 10)
                    .frame(maxWidth: 70, alignment: .leading)
                
                
                Text(project.name)
                    .truncationMode(.tail)
                    .frame(maxWidth: 270)
                
                    .fontWeight(.bold)
                Spacer()
                Text(project.formatTime(for: .now))
                    .padding(.leading, 10)
            }
            
            DisclosureGroup("More Details.", isExpanded: $IsEdited) {
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("DESCRIPTION")
                        .font(.subheadline)
                        .frame(alignment: .top)
                        .padding(.horizontal, 15) // Padding for leading and trailing
                    
                    TextEditor(text: $project.details)
                        .foregroundColor(.white) // Set the text color to white
                        .padding(.horizontal, 15)
                        .frame(minHeight: 100)
                        .padding(.horizontal, 15)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.5), lineWidth: 2) // Light white border
                        .frame(width: 345, height: 258)
                )
                .frame(width: 345, height: 258)
              
            }
        }
        .foregroundStyle(.white)
        .font(.custom("Avenir", size: 16))
        .background(
            .darkPink
        )
        .ignoresSafeArea()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)
    
        var project1 = Project(name: "name 1", details: "test one: example text a lot of text to cope with maybe even five lines, this could get crazy guys, why did this lady leave the door open. well its a nice breeze.", startDate: .now, tasks: [Task](), entries: [Entry]())
        
        var show = false
        
        let projectBinding = Binding<Project>(
                  get: { project1 },
                  set: { project1 = $0 }
              )
              
              let showBinding = Binding<Bool>(
                  get: { show },
                  set: { show = $0 }
              )
              
        return SelectedProjectView(project: projectBinding, show: showBinding)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
