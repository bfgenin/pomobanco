//
//  Project.swift
//  PomoBanco
//
//  Created by Belish Genin on 9/8/24.
//

import Foundation
import SwiftData

@Model
class Project {
    
    @Attribute(.unique)
    var tasks: [Task]
    
    var title: String
    var details: String

    var entries: [Entry]
    
    init(tasks: [Task], title: String, details: String, entries: [Entry]) {
        self.tasks = tasks
        self.title = title
        self.details = details
        self.entries = entries
    }
    
}
