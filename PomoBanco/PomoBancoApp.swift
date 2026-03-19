//
//  PomoBancoApp.swift
//  PomoBanco
//
//  Created by Belish Genin on 9/5/24.
//

import SwiftUI
import SwiftData

@main
struct PomoBancoApp: App {
    let container = try! ModelContainer(for: Project.self, Entry.self, Tag.self)
    @State private var hasCompletedSeeding = false

    private var shouldSeedPreviewData: Bool {
        CommandLine.arguments.contains("-seedPreviewData")
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if !shouldSeedPreviewData || hasCompletedSeeding {
                    ContentView()
                } else {
                    ProgressView()
                }
            }
            #if DEBUG
            .task {
                guard shouldSeedPreviewData, !hasCompletedSeeding else { return }
                await PreviewSamples.seed(container, reset: true)
                hasCompletedSeeding = true
            }
            #endif
        }
        .modelContainer(container)
    }
}
