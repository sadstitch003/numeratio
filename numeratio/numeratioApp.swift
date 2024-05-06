//
//  numeratioApp.swift
//  numeratio
//
//  Created by Christian on 25/04/24.
//

import SwiftUI
import SwiftData

@main
struct numeratioApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: AverageSpeed.self)
    }
}
