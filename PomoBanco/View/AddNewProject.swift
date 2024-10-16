//
//  AddNewProject.swift
//  PomoBanco
//
//  Created by Belish Genin on 10/5/24.
//

import SwiftUI
import SwiftData

struct AddNewProject: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var name: String = ""
    @State var details: String = ""
    
    @Binding var addProject: Bool
    
    var body: some View {
        
        VStack(spacing: 0) {
            TextField("add a title.", text: $name)
                .wrappedTextFieldStyle(rectangleWidth: 317, rectangleHeight: 38)
        
            
            TextEditor(text: $details)
                .scrollContentBackground(.hidden)
                .frame(width: 317, height: 80)
                .wrappedTextFieldStyle(rectangleWidth: 317, rectangleHeight: 80)

            
            Button(action: save) {
                Text("Save")
                    .background(.hotPink)
                    .frame(width: 100)
            }
        }
        .font(.custom("Avenir", size: 20))
        .foregroundStyle(.white)
       // .background(.darkPink)
    }

    func save() {
        let newProject = Project(id: UUID(), name: name, details: details, startDate: .now, tasks: [], entries: [])
    
        do {
            modelContext.insert(newProject)
            try modelContext.save()
            
            addProject = false
            // TO DO:
            // reset animation + fields empty 
        } catch {
            print("Failed to save project: \(error.localizedDescription)")
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)

        var addProject = false
        let addBinding = Binding<Bool>(
            get: { addProject },
            set: { addProject = $0 }
        )
        
        
        return AddNewProject(addProject: addBinding)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
