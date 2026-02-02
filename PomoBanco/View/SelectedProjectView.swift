import SwiftUI
import SwiftData

struct SelectedProjectView: View {
    @Environment(\.modelContext) var modelContext

    @Binding var selectedProject: Project?
    @Binding var isExpanded: Bool

    // ✅ geometry-driven sizing from parent
    let maxExpandedHeight: CGFloat
    let collapsedHeight: CGFloat

    // strings
    @State private var details: String = ""
    @State private var name: String = ""

    @State private var isDescription = true
    @State private var isSubTasks = true
    @State private var isChart = true

    @Namespace private var namespace

    private var barColor: Color {
        Color.from(name: selectedProject?.tag?.color ?? "red")
    }

    private var barGradient: LinearGradient {
        LinearGradient(
            colors: [barColor.opacity(0.95), barColor.opacity(0.55)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var body: some View {
        if let selectedProject = selectedProject {

            VStack(alignment: .center, spacing: 2) {
                ProjectRowView(project: selectedProject, fontSize: 24, height: 70, cornerRadius: 25) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -100 {
                                withAnimation { deselectProject() }
                            }
                        }
                )

                if isExpanded {
                    ScrollView(showsIndicators: true) {
                        ExpandedView(project: selectedProject)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            // ✅ cap height: expand within available space
//            .frame(maxWidth: .infinity, alignment: .top)
            //    .frame(height: isExpanded ? maxExpandedHeight : collapsedHeight, alignment: .top)
      //      .clipped()
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isExpanded)

        } else {
            Text("select a project")
                .foregroundStyle(.white)
                .font(.custom("Avenir", size: 24))
                .fontWeight(.bold)
                .opacity(0.20)
                .matchedGeometryEffect(id: "selected-project", in: namespace)
                .background(
                    .ultraThinMaterial.opacity(0.2),
                    in: RoundedRectangle(cornerRadius: 25, style: .continuous)
                )
        }
    }

    private func deselectProject() {
        selectedProject = nil
        isExpanded = false
        details = ""
        name = ""
    }

    // ✅ unchanged styling inside
    private func ExpandedView(project: Project) -> some View {
        VStack(alignment: .leading, spacing: 5){
            if let tag = project.tag  {
                Text(tag.name)
                    .padding(.horizontal, 8)
                    .background(barColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Text("DESCRIPTION")

            TextField("add description here", text: $details)
                .background(
                    ZStack {
                        Rectangle().fill(.ultraThinMaterial)
                        Rectangle().fill(Color.darkPink.opacity(0.20))
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Text("CHART")
            if (selectedProject != nil) {
                ChartView(project: project)
                    .background(
                        ZStack {
                            Rectangle().fill(.ultraThinMaterial)
                            Rectangle().fill(Color.hotPink.opacity(0.20))
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            Text("Created: \(DateFormatter.localizedString(from: project.startDate, dateStyle: .long, timeStyle: .short))")
                .font(.custom("Avenir", size: 12))
        }
        .foregroundStyle(.white)
        .font(.custom("Avenir", size: 16))
    }
}

#Preview("SelectedProjectView") {
    @Previewable @State var isExpanded = true
    @Previewable @State var selectedProject: Project? = nil

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Project.self, Tag.self, configurations: config)

    let sampleProject = PreviewSamples.sampleProject()

    return SelectedProjectView(
        selectedProject: $selectedProject,
        isExpanded: $isExpanded,
        maxExpandedHeight: 420,
        collapsedHeight: 72
    )
    .frame(width: 360, height: 700) // gives it room to show scroll behavior
    .padding()
    .modelContainer(container)
    .task {
        container.mainContext.insert(sampleProject)
        selectedProject = sampleProject
    }
}
