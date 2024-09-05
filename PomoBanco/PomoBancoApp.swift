//
//  PomoBancoApp.swift
//  PomoBanco
//
//  Created by Belish Genin on 9/5/24.
//

import SwiftUI

@main
struct PomoBancoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Project.self)
    }
}
