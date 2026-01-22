//
//  Entry.swift
//  PomoBanco
//
//  Created by Belish Genin on 9/10/24.
//

import Foundation
import SwiftData

@Model
class Entry {
    var date: Date
    var duration: Float
    
    init(date: Date, duration: Float) {
        self.date = date
        self.duration = duration
    }
    
}
