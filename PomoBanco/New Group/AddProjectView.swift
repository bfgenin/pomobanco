import SwiftUI
import SwiftData

struct AddProjectView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var details = ""
    
    @State private var exapandedWidth = 300
    @State private var expandedHeight: CGFloat = 300
    
    @State private var expand = true
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            
            ZStack(alignment: .topLeading) {
                
                Rectangle()
                    .fill(.lightPink)
                    .frame(width: 300, height: 20)
                    .fixedSize()
                    .zIndex(3)
                    .onTapGesture() {
                        withAnimation(.smooth(duration: 0.9))
                        {
                            self.expand.toggle()
                        }
                    }
            
                Text("Add Project Here")
                    .zIndex(4)
                    .foregroundStyle(.darkBlue)
                
                //.disabled(!expand)
                
                
                Rectangle()
                    .fill(.lightPink)
                    .frame(height: expand ? 200 : 20)
                    .zIndex(1)
                    .onTapGesture() {
                        withAnimation(.smooth(duration: 0.9))
                        {
                            self.expand.toggle()
                        }
                    }
                
                VStack {
                    TextField("Add Text Here", text: $details, axis: .vertical)
                        .lineLimit(2, reservesSpace: true)
                        .background(Color.white)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 280, height: 100) // Ensure it's fixed
//                        .padding(.top, expand ? 20 : 0)
                        .padding(.leading, 10)
                        .opacity(expand ? 1 : 0) // Only show when expanded
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 280, height: 50)
                        .padding(.leading, 10)
                        .opacity(expand ? 1 : 0) // Only show when expanded
                    //TextField("Add ")
                    
                    Button("Save") {
                        saveProject()
                    }
                    .frame(width: 40, height: 40) // Ensure it's fixed
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .background(.darkPink)
                    .padding(.top, expand ? 20 : 0)
                    .opacity(expand ? 1 : 0) // Only show when expande
                    .tint(.darkBlue)
                }
                .zIndex(2)
            }
            .frame(width: 300, height: 200)
            .fixedSize()
        }
        .frame(width: 300, height: expand ? 200 : 20)
        // .border(.yellow, width: 4)
        
    }
    
    func saveProject() {
        let project = Project(name: title, details: details, startDate: .now, tasks: [Task](), entries: [Entry]())
        modelContext.insert(project)
        withAnimation {
            expand.toggle()
        }
    }
}

struct AnimatingCellHeight: AnimatableModifier {
    var height: CGFloat = 0

    var animatableData: CGFloat {
        get { height }
        set { height = newValue }
    }

    func body(content: Content) -> some View {
        content.frame(height: height)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)
        return AddProjectView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

//     VStack {
//ZStack(alignment: .topLeading) {
//    Rectangle()
//        .fill(Color.red)
//        .frame(width: 100, height: 100)
//        .zIndex(1)
//        .onTapGesture {
//            withAnimation(.easeIn) {
//                self.expand.toggle()
//            }
//        }
//
//    Rectangle()
//        .fill(Color.blue)
//        .frame(width: 100, height: 100)
//        .alignmentGuide(.top, computeValue: {
//            dimension in dimension[.top] - (self.expand ? 50 : 0) })
//        .animation(.easeIn, value: expand)
//
//    Text("Row 3")
//}
//}
