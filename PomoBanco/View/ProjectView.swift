//
//  TaskView.swift
//  PomoBanco
//
//  Created by Belish Genin on 9/6/24.
//

import SwiftUI
import SwiftData

struct ProjectView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var task: Project
    var focusMode: Bool
    var width: Double = 200
    var onSelect: (() -> Void)?
    @State private var offset: CGFloat = 0.0
    @State private var onTap: Bool = false
    @State private var showEditTask = false
    
    var body: some View {
        ZStack {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack() {
                        
                        Text(task.name)
                            .font(.system(size: 17))
                            .foregroundColor(.darkBlue)
                        
                        //Spacer()
                        Text(String(task.formatTime(for: Date.now)))
                            .frame(width: 50, height: 17)
                            .background(focusMode ? .darkBlue : .darkPink)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .frame(maxHeight: 30, alignment: .top)
                    
                    Text(task.details)
                        .font(.system(size: 17))
                        .foregroundColor(.darkBlue)
                        .padding(.top, 3)
                        .padding(.leading, 3)
                        .frame(width: 315, height: onTap ? 100 : 41)
                        .background(Color.white)
                        .clipShape(Rectangle())
                        .padding(.bottom, 7)
                }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    onTap.toggle()
                    onSelect?()
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation {
                            if value.translation.width < 0 {
                                offset = value.translation.width
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation {
                            offset = 0.0
                            showEditTask = true
                        }
                    }
            )
            .offset(x: offset)
            .frame(width: 326, height: onTap ? nil : 71, alignment: .top)
            .clipped()
            .foregroundColor(.white)
            .padding()
            .sheet(isPresented: $showEditTask) { // Present EditTask when state is true
                        EditTask(task: task) // Pass in the selected task
                    }
        }
    }
}

struct EditTask: View {
    var task: Project

    var body: some View {
        VStack {
            Text("Editing Task: \(task.name)")
            // Add your editing UI here
            Button("Done") {
                // Handle done action
            }
        }
        .padding()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)
        // Create an entry
        let aEntry = Entry(date: .now, duration: 6000.7800)
//          
//        // Initialize testEntries and append the entry
        var testEntries = [Entry]()
//        testEntries.append(aEntry)
                           
        let fatTask = Project(name: "Fat Task", details:  "Oh boy, I am a big task, I have so many details and information that I just can't help but be huge...MMM...I ate many subtasks, lol!", entries: testEntries)
        return ProjectView(task: fatTask, focusMode: false)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

