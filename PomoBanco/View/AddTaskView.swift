import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var isProject = false
    @State private var title = ""
    @State private var details = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Toggle(isOn: $isProject) {
                    Text("Is This a Project")
                }
                
                if isProject { // PROJECT VIEW
                    Form {
                        TextField("Add Project Name", text: $title)
                        
                        Section("Add Project Details") {
                            TextEditor(text: $details)
                        }
                    }
                } else { // TASK VIEW
                    
                    Form {
                        TextField("Add Task Name", text: $title)
                        
                        Section("Add Task Details") {
                            TextEditor(text: $details)
                        }
                    }
                }
            }
        }
        .toolbar {
            Button("Save") {
                saveTask()
                dismiss()
            }
        }
    }
    
    
    func saveTask() {
        if isProject {
            let project = Project(tasks: [Task](), title: title, details: details, entries: [Entry]())
            modelContext.insert(project)
        } else {
            let task = Task(name: title, details: details, entries: [Entry]())
            modelContext.insert(task)
        }
    }
    
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Task.self, configurations: config)
        return AddTaskView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

