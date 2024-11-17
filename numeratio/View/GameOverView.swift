//
//  GameOverView.swift
//  numeratio
//
//  Created by Christian on 02/05/24.
//

import SwiftUI

struct GameOverView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var gameOver: Bool
    
    let averageCalculationSpeed: Double
    
    var body: some View {
        ZStack {
            VStack {
                Text("Game Over")
                    .bold()
                    .font(.largeTitle)
                
                Text("Average Speed: \(String(format: "%.2f", averageCalculationSpeed)) sec")
                
                Button(action: {
                    gameOver = false
                    dismiss()
                }, label: {
                    Text("Main Menu")
                        .frame(width: 220, height: 40)
                        .foregroundColor(Color.black)
                        .background(Color("InteractiveColor"))
                        .cornerRadius(8)
                })
            }
            .frame(width: 280, height: 160)
            .background(Color("BackgroundColor"))
            .cornerRadius(12)
        }
    }
}

#Preview {
    GameOverView(gameOver: .constant(true), averageCalculationSpeed: 3.4)
}
