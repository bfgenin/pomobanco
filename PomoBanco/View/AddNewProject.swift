import SwiftUI
import SwiftData

struct AddNewProject: View {
    @Environment(\.modelContext) private var modelContext

    @Binding var isExpanded: Bool

    // Fields
    @State private var name: String = ""
    @State private var details: String = ""

    private let defaultTags = ["Work", "Personal", "Health", "School"]

    @Query(sort: \Tag.name) private var tags: [Tag]
    @State private var selectedTag: Tag? = nil

    @State private var showAddTagDialog: Bool = false
    @State private var newTagName: String = ""

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HeaderRow

            if isExpanded {
                ExpandedForm
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.vertical, 8)
        .font(.custom("Avenir", size: 20))
        .foregroundStyle(.white)
        .background(.darkPink)
        .onAppear { seedDefaultTagsIfNeeded() }
    }

    private var HeaderRow: some View {
        HStack {
            Text("New Project")
                .font(.custom("Avenir", size: 24))
                .fontWeight(.bold)

            Spacer()

            Image(systemName: isExpanded ? "chevron.down" : "chevron.up")
                .font(.system(size: 16, weight: .semibold))
                .opacity(0.9)
        }
        .padding(.horizontal, 16)
        .frame(height: 70)
        .background(
            .ultraThinMaterial.opacity(0.2),
            in: RoundedRectangle(cornerRadius: 25, style: .continuous)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isExpanded.toggle()
            }
        }
    }

    private var ExpandedForm: some View {
        // Keep ScrollView so it behaves well with keyboard
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(.custom("Avenir", size: 16))
                        .opacity(0.9)

                    TextField("add a title", text: $name)
                        .textInputAutocapitalization(.sentences)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                        )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.custom("Avenir", size: 16))
                        .opacity(0.9)

                    TextField("optional: add details", text: $details, axis: .vertical)
                        .lineLimit(3...8)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                        )
                }

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
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                        )
                    }
                }

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
        .alert("New label", isPresented: $showAddTagDialog) {
            TextField("Label name", text: $newTagName)
            Button("Cancel", role: .cancel) { newTagName = "" }
            Button("Add") { addTag() }
        } message: {
            Text("Create a new tag to use for this project.")
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

            // reset + collapse (same feel)
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
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
