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
    var averageSpeed: Double
    
    init(date: Date, averageSpeed: Double) {
        self.id = UUID().uuidString
        self.date = date
        self.averageSpeed = averageSpeed
    }
}
