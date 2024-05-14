//
//  MainContent.swift
//  numeratio
//
//  Created by Kristanto Sean on 14/05/24.
//

import SwiftUI

struct MainContent: View {
    let currentQuestion: String
    let userInput: String
    
    var body: some View {
        HStack {
            Text("\(currentQuestion) = ")
                .bold()
                .font(.system(size: 32))
            
            Text("\(userInput)")
                .bold()
                .font(.system(size: 32))
                .padding()
                .frame(width: 120, height: 60)
                .background(Color("BackgroundColor"))
                .cornerRadius(10)
        }
        .frame(minWidth: 320, maxWidth: 320)
        .padding()
    }
}

#Preview {
    MainContent(currentQuestion: "5 * 2", userInput: "10")
}
