//
//  EditProjectView.swift
//  PomoBanco
//
//  Created by Belish Genin on 9/23/24.
//

import SwiftUI
import SwiftData

struct OldEditProjectView: View {
    @State var project: Project
    @State private var focusMode = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                TextField("", text: $project.name)
                    .font(.system(size: 17))
                    .foregroundStyle(.darkBlue)
                    .padding(.horizontal)
                
                Text(String(project.formatTime(for: Date.now)))
                    .font(.system(size: 17))
                    .frame(width: 50, height: 17)
                    .background(focusMode ? .darkBlue : .darkPink)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.trailing)
            }
            .clipShape(Rectangle())
            .background(.darkPink)
            
            if let type = project.tag {
                Text(type)
                    .background(.darkPink)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.leading)
            } else {
                Text("add type") // Alternative view if project.type is nil
                    .foregroundColor(.gray)
                    .padding(.leading)
            }
            
            
            Text("Project Details")
                .font(.system(.subheadline))
            TextField("Project Details", text: $project.details)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .font(.headline)
                .foregroundColor(.darkBlue)
            
            Text("Project Details")
                .font(.system(.subheadline))
            
//            List(project.tasks) { task in
//                Text(task.title)
//            }

            TextField("Project Details", text: $project.details)
                .padding()
                .frame(height: 90)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .font(.headline)
                .foregroundColor(.darkBlue)
            
            
            
            Text("Created: \(project.startDate.formatted(.dateTime.month().day().year()))")
                .foregroundStyle(.darkBlue)
            
            
        }
        .background(.medPink)
        .frame(width: 300, height: 350)
        .border(.yellow, width: 4)
    }
}

//                Rectangle()
//                    .fill(.darkPink)
//                    .frame(height: 20)
//                    .zIndex(2)
//
//                Rectangle()
//                .fill(.lightPink)

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)
        let task1 = Task(title: "kill myself", complete: false)
        let task2 = Task(title: "love myself", complete: false)
        let tasks: [Task] = [task1, task2]
        
        let project = Project(id: UUID(), name: "Test Project", details: "TEST PROJECT DETAILS", startDate: .now, tasks: tasks, entries: [Entry]())
        
        return OldEditProjectView(project: project)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
