//
//  AverageSpeed.swift
//  numeratio
//
//  Created by Christian on 04/05/24.
//

import Foundation
import SwiftData

@Model
class AverageSpeed: Identifiable {
    var id: String
    var date: Date
    var level: Int
    var averageSpeed: Double
    
    init(date: Date, level: Int, averageSpeed: Double) {
        self.id = UUID().uuidString
        self.date = date
        self.level = level
        self.averageSpeed = averageSpeed
    }
}
