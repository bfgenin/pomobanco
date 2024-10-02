//
//  Task.swift
//  PomoBanco
//
//  Created by Belish Genin on 9/22/24.
//

import Foundation
import SwiftData

@Model
class Task {
    var id = UUID()
    var title: String
    var complete: Bool
    
    init(title: String, complete: Bool) {
        self.title = title
        self.complete = complete
    }
    
    func completeTask() {
        self.complete.toggle()
    }
}
