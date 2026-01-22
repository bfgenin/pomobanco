import SwiftUI
import SwiftData


struct AddNewProject: View {
    @Environment(\.modelContext) private var modelContext

    // Fields
    @State private var name: String = ""
    @State private var details: String = ""


    private let defaultTags = [
        "Work",
        "Personal",
        "Health",
        "School"
    ]

    @Query(sort: \Tag.name) private var tags: [Tag]
    @State private var selectedTag: Tag? = nil
    
    // UI state
    @State private var expandProject: Bool = false
    @State private var showTagMenu: Bool = false
    @State private var showAddTagDialog: Bool = false
    @State private var newTagName: String = ""


    var body: some View {
        VStack(spacing: 0) {

            // Top handle + (optional) title row
            VStack(spacing: 12) {
                Button {
                    withAnimation { expandProject.toggle() }
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 10)
                        .padding(.vertical)
                }

                if expandProject {
                    Text("New Project")
                        .font(.custom("Avenir", size: 22))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)

            if expandProject {
                // Use ScrollView so it behaves well on small screens / with keyboard
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        // 1) Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.custom("Avenir", size: 16))
                                .opacity(0.9)

                            TextField("add a title", text: $name)
                                .textInputAutocapitalization(.sentences)
                                .padding(12)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.12)))
                        }

                        // 2) Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.custom("Avenir", size: 16))
                                .opacity(0.9)

                            TextField("optional: add details", text: $details, axis: .vertical)
                                .lineLimit(3...8)
                                .padding(12)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.12)))
                        }

                        // 3) Tag selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tag")
                                .font(.custom("Avenir", size: 16))
                                .opacity(0.9)

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
                                    Label("Add new label", systemImage: "plus")
                                }
                            } label: {
                                HStack {
                                    Text(selectedTag?.name ?? "Select a tag")
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                }
                            }
                        }

                        // Push Save to bottom (within scroll content, this ensures spacing)
                        Spacer(minLength: 24)

                        Button(action: save) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(canSave ? Color.gray : Color.gray.opacity(0.4))
                                )
                        }
                        .disabled(!canSave)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
                .scrollDismissesKeyboard(.interactively)
            } else {
                // collapsed height filler if you want
                Spacer(minLength: 0)
            }
        }
        // THIS is the key to “don’t center when expanded”
        // Keep everything pinned to the top
        .frame(maxWidth: .infinity, maxHeight: expandProject ? 500 : 200, alignment: .top)

        .font(.custom("Avenir", size: 20))
        .foregroundStyle(.white)
        .background(.darkPink)
        .onAppear {
            seedDefaultTagsIfNeeded()
        }

        // Add-tag dialog
        .alert("New label", isPresented: $showAddTagDialog) {
            TextField("Label name", text: $newTagName)
            Button("Cancel", role: .cancel) { newTagName = "" }
            Button("Add") { addTag() }
        } message: {
            Text("Create a new tag to use for this project.")
        }
    }

    private func seedDefaultTagsIfNeeded() {
        // If ANY tags already exist, do nothing
        guard tags.isEmpty else { return }

        defaultTags.forEach { name in
            _ = TagModel.createOrFetch(
                name: name,
                context: modelContext
            )
        }
    }
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
            withAnimation { expandProject = false }
        } catch {
            print("Failed to save project: \(error.localizedDescription)")
        }
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
        
        return AddNewProject()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
