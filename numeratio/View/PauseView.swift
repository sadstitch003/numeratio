//
//  PauseView.swift
//  numeratio
//
//  Created by Christian on 02/05/24.
//

import SwiftUI

struct PauseView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var gamePaused: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                Text("Game Paused")
                    .bold()
                    .font(.largeTitle)
                
                Button(action: {
                    gamePaused = false
                    dismiss()
                }, label: {
                    Text("Resume")
                        .frame(width: 220, height: 40)
                        .foregroundColor(Color.black)
                        .background(Color("InteractiveColor"))
                        .cornerRadius(8)
                })
                
            }
            .frame(width: 280, height: 160)
            .background(Color("BackgroundColor"))
            .cornerRadius(16)
        }
    }
}

#Preview {
    PauseView(gamePaused: .constant(true))
}
