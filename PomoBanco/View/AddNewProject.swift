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
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var details: String = ""
    
    @Binding var addProject: Bool
    
    var body: some View {
        ZStack {
           
            VStack {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.darkPink)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(1), lineWidth: 2)
                        )
                        .frame(width: 317, height: 38)
                    
                    TextField("add a title.", text: $name)
                        .padding(.leading, 20)
                        .frame(width: 317, height: 38)
                        .background(Color.clear)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.8), lineWidth: 2)
                        .frame(width: 317, height: 181)
                    TextEditor(text: $details)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 15)
                        .frame(width: 317, height: 120)
                    
                }
                Button(action: save) {
                    Text("Save")
                        .background(.hotPink)
                        .frame(width: 100)
                }
                .font(.custom("Avenir", size: 20))
            }
        }
        .foregroundStyle(.white)
    }
    
    func save() {
        let newProject = Project(name: name, details: details, startDate: .now, tasks: [Task](), entries: [Entry]())
        modelContext.insert(newProject)
        withAnimation {
            addProject = false
        }
        dismiss()
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
