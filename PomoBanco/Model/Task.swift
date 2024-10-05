//
//  Task.swift
//  PomoBanco
//
//  Created by Belish Genin on 9/22/24.
//

import Foundation
import SwiftData

@Model
class Task: Hashable {
    var id = UUID()
    var title: String
    var complete: Bool
    
    init(title: String, complete: Bool) {
        self.id = UUID()
        self.title = title
        self.complete = complete
    }
    static func == (lhs: Task, rhs: Task) -> Bool {
          return lhs.id == rhs.id
      }
      
      func hash(into hasher: inout Hasher) {
          hasher.combine(id)
      }
      
    
    func completeTask() {
        self.complete.toggle()
    }
}
