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
    var Date: Date
    var Duration: Float
    
    init(Date: Date, Duration: Float) {
        self.Date = Date
        self.Duration = Duration
    }
}
