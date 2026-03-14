import SwiftUI
import SwiftData

struct SelectedProjectView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Tag.name) private var tags: [Tag]
    
    @Binding var selectedProject: Project?
    @Binding var isExpanded: Bool
    
    @State private var showAddTagDialog: Bool = false
    @State private var newTagName: String = ""
    
    // geometry-driven sizing from parent
    let maxExpandedHeight: CGFloat
    let collapsedHeight: CGFloat
    
    // strings
    @State private var details: String = ""
    @State private var name: String = ""
    
    @Namespace private var namespace
    
    private var barColor: Color {
        Color.from(name: selectedProject?.tag?.color ?? AppConstants.defaultTagColor)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            if let selectedProject {
                
                ProjectRowView(
                    project: selectedProject,
                    fontSize: AppTheme.avenirHeadline,
                    height: AppLayout.rowHeightExpanded,
                    cornerRadius: AppLayout.cornerRadiusRow
                ) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.85)) {
                        isExpanded.toggle()
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 40, coordinateSpace: .local)
                        .onEnded { value in
                            // Swipe left to deselect
                            if value.translation.width < -40 {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    deselectProject()
                                }
                            }
                        }
                )
                
                if isExpanded {
                    ScrollView {
                        ExpandedView(project: selectedProject)
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .frame(maxWidth: .infinity)
        
    }
    private func deselectProject() {
        selectedProject = nil
        isExpanded = false
        details = ""
        name = ""
    }
    private func addNewTag() {
        let trimmed = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let tag = TagModel.createOrFetch(name: trimmed, context: modelContext)
        selectedProject?.tag = tag
        newTagName = ""
    }
    
    private func ExpandedView(project: Project) -> some View {
        let totalSeconds = Int(project.time)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        return VStack(alignment: .leading, spacing: AppLayout.spacingLarge) {
            HStack {
                Menu {
                    ForEach(tags) { tag in
                        Button {
                            project.tag = tag
                        } label: {
                            if project.tag?.id == tag.id {
                                Label(tag.name, systemImage: "checkmark")
                            } else {
                                Text(tag.name)
                            }
                        }
                    }
                    Button {
                        showAddTagDialog = true
                    } label: {
                        Label(AppStrings.addNewLabel, systemImage: "plus")
                    }
                } label: {
                    Text(project.tag?.name ?? AppStrings.addTag)
                        .padding(.horizontal, AppLayout.paddingMedium)
                        .background(project.tag != nil ? barColor : Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadiusSmall))
                }
                Spacer()
                HStack(spacing: AppLayout.spacingTight) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text("\(hours)h \(minutes)m")
                        .font(AppTheme.avenir(size: AppTheme.avenirCaption))
                }
                .foregroundStyle(.white.opacity(0.75))
                .padding(.horizontal, AppLayout.paddingMedium)
                .padding(.vertical, AppLayout.paddingSmall / 2)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppLayout.cornerRadiusSmall))
            }
            .padding(.horizontal, AppLayout.paddingTight)
            TextField(
                AppStrings.addDescriptionPlaceholder,
                text: Binding(
                    get: { project.details },
                    set: { newVal in
                        project.details = String(newVal.prefix(AppConstants.projectDescriptionLimit))
                    }
                ),
                axis: .vertical
            )
            .lineLimit(3...8)
            .padding(AppLayout.paddingStandard)
            .background(
                .ultraThinMaterial.opacity(0.2),
                in: RoundedRectangle(cornerRadius: AppLayout.cornerRadiusMedium, style: .continuous)
            )
            if selectedProject != nil {
                ChartView(project: project)
                    .frame(maxHeight: 355)
                    .background(
                        .ultraThinMaterial.opacity(0.2),
                        in: RoundedRectangle(cornerRadius: AppLayout.cornerRadiusMedium, style: .continuous)
                    )
            }
            Text("Created: \(DateFormatter.localizedString(from: project.startDate, dateStyle: .long, timeStyle: .short))")
                .font(AppTheme.avenir(size: AppTheme.avenirCaption))
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
        }
        .addTagAlert(
            isPresented: $showAddTagDialog,
            tagName: $newTagName,
            message: AppStrings.createTagMessageEdit,
            onAdd: addNewTag
        )
        .foregroundStyle(.white)
        .font(AppTheme.avenir(size: AppTheme.avenirBodyLarge))
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
    .modelContainer(container)
    .task {
        container.mainContext.insert(sampleProject)
        selectedProject = sampleProject
    }
    .background(Color.darkBlue)
}
