import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var projects: [Project]
    @Query private var tasks: [Task]
    
    @State private var focusMode = false
    @State private var selectedTask: Task? = nil 
    
    var body: some View {
           NavigationStack {
               ZStack {
                   LinearGradient(colors: focusMode ? [Color.darkBlue, Color.lightPink] : [Color.darkPink, Color.lightPink], startPoint: .bottom, endPoint: .top)
                       .ignoresSafeArea()
                   
                   VStack {
                       TimerView(task: selectedTask, focusMode: $focusMode)
                       
                       if let selectedTask = selectedTask {
                           Text("Currently Working on: \(selectedTask.name)")
                               .font(.headline)
                               .padding()
                       } else {
                           Text("Select a task to work on")
                               .font(.headline)
                               .padding()
                       }
                       
                       List {
                           ForEach(tasks, id: \.self) { task in
                               TaskView(task: task, focusMode: false) {
                                   selectedTask = task // Update selected task on tap
                               }
                           }
                           .listRowBackground(Color.clear)
                       }
                       .background(Color.clear)
                       .listStyle(PlainListStyle())
                       
                   
                       
                       NavigationLink("Tap Me") {
                           AddTaskView()
                       }
                   }
                   
               }
           }
       }
   }

#Preview {
    ContentView()
}
