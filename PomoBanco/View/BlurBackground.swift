//
//  BlurBackground.swift
//  PomoBanco
//
//  Created by Belish Genin on 11/1/24.
//

import SwiftUI
import SwiftData

struct BlurBackground: View {
    var focusMode: Bool

    var body: some View {
        ZStack {
            Image("BlueScroll")
                .resizable()
                .scaledToFill()
                .scaleEffect(1.01)
                .ignoresSafeArea()
          //      .opacity(focusMode ?  : 0)
            
            Image("TestScroll")
                .resizable()
                .scaledToFill()
                .scaleEffect(1.01)
                .ignoresSafeArea()
                .opacity(focusMode ? 0 : 1)
            
          
        }
        
        .animation(.smooth(duration: 2), value: focusMode)
    }
}

#Preview {
    @Previewable @State var focusMode = false

    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)


        return BlurBackground(focusMode: focusMode)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
