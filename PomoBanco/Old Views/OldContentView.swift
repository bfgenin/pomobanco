//
//  OldContentView.swift
//  PomoBanco
//
//  Created by Belish Genin on 9/26/24.
//

import SwiftUI
import SwiftData

struct OldContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var projects: [Project]
    
    @State private var focusMode = false
    @State private var selectedProject: Project? = nil
    
    var body: some View {
           NavigationStack {
               ZStack {
                   LinearGradient(colors: focusMode ? [Color.darkBlue, Color.lightPink] : [Color.darkPink, Color.lightPink], startPoint: .bottom, endPoint: .top)
                       .ignoresSafeArea()
                   
                   VStack {
                       TimerView(project: selectedProject, focusMode: $focusMode)
                       
                       
                       if let selectedTask = selectedProject {
                           Text("Currently Working on: \(selectedTask.name)")
                               .font(.headline)
                               .padding()
                       } else {
                           Text("Select a task to work on")
                               .font(.headline)
                               .padding()
                       }
                       
    
                       OldAddProjectView()
                       
                       List {
                    
                           
                           ForEach(projects, id: \.self) { task in
                               OldProjectView(task: task, focusMode: false) {
                                   selectedProject = task // Update selected task on tap
                               }
                           }
                           .listRowBackground(Color.clear)
                       }
                       .background(Color.clear)
                       .listStyle(PlainListStyle())
                       
                   
                    
                   }
                   
               }
           }
       }
   }



#Preview {
    OldContentView()
}
