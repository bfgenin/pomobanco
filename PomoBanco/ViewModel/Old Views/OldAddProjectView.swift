import SwiftUI
import SwiftData

struct OldAddProjectView: View {
    
    @State private var expand = true
    @Namespace var namespace
    
    var body: some View {
        
        VStack {
//            withAnimation {
//                Toggle("Expand", isOn: $expand)
//            }
            Rectangle()
                .fill(.red)
                .frame(height: 30)
            
            DisclosureGroup("", isExpanded: $expand) {
                Text("Some silly little details.")
            }
            .border(.red)
            .frame(width: 300)
            .matchedGeometryEffect(id: "lol", in: namespace)
        }
    }
}



#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)
        return OldAddProjectView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}


