//
//  GameHistory.swift
//  numeratio
//
//  Created by Christian on 04/05/24.
//

import SwiftUI
import SwiftData
import Charts

struct GameHistoryView: View {
    
    @State var viewModel = GameHistoryViewModel()
    
    @Environment(\.modelContext) private var context

    
    var body: some View {
        NavigationStack {
            VStack {
                if (viewModel.averageSpeedHistory.count == 0) {
                    Text("No Data")
                } else {
                    Chart {
                        ForEach(viewModel.latestData, id: \.id) { data in
                            LineMark(
                                x: .value("Date", data.date.formatted(date: .abbreviated, time: .shortened)),
                                y: .value("Average Speed", data.averageSpeed)
                            )
                            
                            PointMark(
                                x: .value("Date", data.date.formatted(date: .abbreviated, time: .shortened)),
                                y: .value("Average Speed", data.averageSpeed)
                            )
                            .annotation(
                                position: .overlay,
                                alignment: .bottom,
                                spacing: 10
                            ) {
                                Text(String(format: "%.2f", data.averageSpeed))
                            }
                       }
                    }
                    .frame(height: 200)
                    .padding()
                    .chartYAxis {
                        AxisMarks(preset: .inset, position: .trailing, values: .stride(by: 1))
                    }
                    
                    List {
                        ForEach (viewModel.averageSpeedHistory.sorted { $0.date > $1.date }) { data in
                            HStack {
                                VStack{
                                    HStack {
                                        Text("Level \(data.level)")
                                            .bold()
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(data.date.formatted(date: .abbreviated, time: .shortened))")
                                            .font(.caption)
                                        Spacer()
                                    }
                                }
                                Text(String(format: "%.2f sec", data.averageSpeed))
                            }
                        }
                        .onDelete { indexes in
                            for index in indexes {
                                viewModel.deleteData(viewModel.averageSpeedHistory[index])
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Game History")
        }
        .onAppear {
            viewModel.context = context
            viewModel.fetchData()
        }
    }
}



#Preview {
    GameHistoryView()
}
