import SwiftUI
import SwiftData

struct AddNewProject: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isExpanded: Bool

    // Fields
    @State private var name: String = ""
    @State private var details: String = ""

    private let defaultTags = AppConstants.defaultTagNames

    @Query(sort: \Tag.name) private var tags: [Tag]
    @State private var selectedTag: Tag? = nil

    @State private var showAddTagDialog: Bool = false
    @State private var newTagName: String = ""

    var body: some View {
        VStack(spacing: 0) {
            
            HeaderRow
                .zIndex(2)
            
//        ZStack(alignment: .top) {
                if isExpanded {
                    ExpandedForm
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
          //  }
          //  .frame(maxHeight: isExpanded ? 425 : 0, alignment: .top)
        }

        .padding(.vertical, 8)
        .font(.custom("Avenir", size: 20))
        .foregroundStyle(.white)
        .onAppear { seedDefaultTagsIfNeeded() }
        
    }

    private var HeaderRow: some View {
        HStack {
            Image(systemName: isExpanded ? "chevron.up" : "plus")
                .font(.system(size: 16, weight: .semibold))
                .opacity(0.9)
                .padding(.horizontal, 16)
                .padding(.vertical)
                .background(
                    
                    .ultraThinMaterial.opacity(0.2),
                    in: RoundedRectangle(cornerRadius: 25, style: .continuous)
                )
                .contentShape(Rectangle())
            
            
            if isExpanded {
                Text(AppStrings.newProject)
                    .font(.custom("Avenir", size: 24))
                    .fontWeight(.bold)
                
            }
            Spacer()
        }
        //.padding(.horizontal, 16)
        .frame(height: 48  )
        
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.85)) {
                isExpanded.toggle()
            }
        }
    }

    private var ExpandedForm: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(AppStrings.name)
                        .font(.custom("Avenir", size: 16))
                        .opacity(0.9)
                    
                    TextField(AppStrings.addTitlePlaceholder, text: $name)
                        .textInputAutocapitalization(.sentences)
                        .padding(12)
                        .background(
                            .ultraThinMaterial.opacity(0.2),
                            in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                        )
                        .onChange(of: name) { _, newVal in
                            if newVal.count > AppConstants.projectTitleLimit {
                                name = String(newVal.prefix(AppConstants.projectTitleLimit))
                            }
                        }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(AppStrings.description)
                        .font(.custom("Avenir", size: 16))
                        .opacity(0.9)
                    
                    TextField(AppStrings.addDetailsPlaceholder, text: $details, axis: .vertical)
                        .lineLimit(3...8)
                        .padding(12)
                        .background(
                            .ultraThinMaterial.opacity(0.2),
                            in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                        )
                        .onChange(of: details) { _, newVal in
                            if newVal.count > AppConstants.projectDescriptionLimit {
                                details = String(newVal.prefix(AppConstants.projectDescriptionLimit))
                            }
                        }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(AppStrings.tag)
                        .font(.custom("Avenir", size: 16))
                        .opacity(1)
                    
                    Menu {
                        ForEach(tags) { tag in
                            Button {
                                selectedTag = tag
                            } label: {
                                if selectedTag?.id == tag.id {
                                    Label(tag.name, systemImage: "checkmark")
                                } else {
                                    Text(tag.name)
                                }
                            }
                        }
                        
                        Divider()
                        
                        Button {
                            showAddTagDialog = true
                        } label: {
                            Label(AppStrings.addNewLabel, systemImage: "plus")
                        }
                    } label: {
                        HStack {
                            Text(selectedTag?.name ?? AppStrings.selectTag)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding(12)
                        .background(
                            .ultraThinMaterial.opacity(0.2),
                            in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                        )
                    }
                }
                
                Button(action: save) {
                    Text(AppStrings.save)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundStyle(canSave ? .white : .white.opacity(0.4))
                        .background(
                            .ultraThinMaterial.opacity(0.2),
                            in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                        )
                }
                .disabled(!canSave)
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
          //  .padding(.horizontal)
            .padding(.bottom, 24)
        }
        
        .scrollDismissesKeyboard(.interactively)
        .alert(AppStrings.newLabel, isPresented: $showAddTagDialog) {
            TextField(AppStrings.labelName, text: $newTagName)
            Button(AppStrings.cancel, role: .cancel) { newTagName = "" }
            Button(AppStrings.add) { addTag() }
        } message: {
            Text(AppStrings.createTagMessageNew)
        }
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func seedDefaultTagsIfNeeded() {
        guard tags.isEmpty else { return }
        defaultTags.forEach { name in
            _ = TagModel.createOrFetch(name: name, context: modelContext)
        }
    }

    private func addTag() {
        let trimmed = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let tag = TagModel.createOrFetch(name: trimmed, context: modelContext)
        selectedTag = tag
        newTagName = ""
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let newProject = Project(
            id: UUID(),
            name: trimmedName,
            details: details,
            startDate: .now,
            tag: selectedTag,
            entries: []
        )

        do {
            modelContext.insert(newProject)
            try modelContext.save()

            // reset + collapse
            name = ""
            details = ""
            selectedTag = nil
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isExpanded = false
            }
        } catch {
            print("Failed to save project: \(error.localizedDescription)")
        }
    }
}

#Preview {
    
        @Previewable @State var isExpanded = false
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)

        var addProject = false
        let addBinding = Binding<Bool>(
            get: { addProject },
            set: { addProject = $0 }
        )
        
        return AddNewProject(isExpanded: $isExpanded)
            .background(.darkPink)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
