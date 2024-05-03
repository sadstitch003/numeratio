//
//  AnalyzeResult.swift
//  numeratio
//
//  Created by Christian on 04/05/24.
//

import SwiftUI
import SwiftData

struct AnalyzeResult: View {
    @Query private var averageSpeedHistory: [AverageSpeed]
    
    var body: some View {
        NavigationStack {
            VStack {
                if (averageSpeedHistory.count == 0) {
                    Text("No Data")
                } else {
                    List {
                        ForEach (averageSpeedHistory) { data in
                            HStack {
                                Text("\(data.date.formatted(date: .abbreviated, time: .shortened))")
                                Spacer()
                                Text("\(data.averageSpeed)")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Game History")
        }
    }
}

#Preview {
    AnalyzeResult()
}
