//
//  ProjectViewRow.swift
//  PomoBanco
//
//  Created by Belish Genin on 1/21/26.
//


import SwiftUI
import SwiftData

struct ProjectRowView: View {
    let project: Project
    var fontSize: CGFloat = 16
    var height: CGFloat = 40
    var cornerRadius: CGFloat = 25
    var showBackground: Bool = true
    var onTap: (() -> Void)? = nil

    var body: some View {
        ZStack {
            HStack {
                if let tag = project.tag {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.from(name: tag.color))
                } else {
                    Circle()
                        .frame(width: 20, height: 20)
                        .opacity(0)
                }
                Spacer()
                Text(project.formatTime(for: .now))
            }
            
            Text(project.name)
                .truncationMode(.tail)
                .fontWeight(fontSize >= 22 ? .bold : .regular)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(height: height)
        .font(.custom("Avenir", size: fontSize))
        .foregroundStyle(.white)
        .padding(.horizontal, 14)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(showBackground ? 0.2 : 0)
        }
        .onTapGesture {
            onTap?()
        }
    }
}



#Preview("ProjectRowView") {
    @Previewable @State var isExpanded = true
    @Previewable @State var selectedProject: Project? = nil
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Project.self, Tag.self, configurations: config)
    
    let sampleProject = PreviewSamples.sampleProject()
    
    return ProjectRowView(project: sampleProject)
}

  
