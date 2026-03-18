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

    var body: some Scene {
        WindowGroup {
            ContentView()
            #if DEBUG
                .task {
                    if CommandLine.arguments.contains("-seedPreviewData") {
                        await PreviewSamples.seed(container)
                    }
                }
            #endif
        }
        .modelContainer(container)
    }
}
