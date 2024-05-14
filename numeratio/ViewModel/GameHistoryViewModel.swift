//
//  GameHistoryViewModel.swift
//  numeratio
//
//  Created by Kristanto Sean on 13/05/24.
//

import Foundation
import SwiftData

@Observable class GameHistoryViewModel {
    
    var context: ModelContext? = nil
    
    var averageSpeedHistory: [AverageSpeed] = []
    
    var latestData: [AverageSpeed] {
        return Array(averageSpeedHistory.sorted { $0.date < $1.date }.prefix(8))
    }
    
    func fetchData() {
        guard let context = context else {
            return
        }

        do {
            let descriptor = FetchDescriptor<AverageSpeed>(sortBy: [SortDescriptor(\.averageSpeed)])
            averageSpeedHistory = try context.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
    
    func deleteData(_ data: AverageSpeed) {
        guard let context = context else {
            return
        }
        
        context.delete(data)
    }
}
