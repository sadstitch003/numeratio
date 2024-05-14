//
//  ScoreAndTime.swift
//  numeratio
//
//  Created by Kristanto Sean on 14/05/24.
//

import SwiftUI

struct ScoreAndTime: View {
    let answeredQuestion: Int
    let totalQuestion: Int
    let formattedTime: String
    
    var body: some View {
        HStack {
            VStack {
                Text("Question")
                    .bold()
                    .font(.subheadline)
                    .opacity(0.3)
                
                Text(String(format: "%02d / %02d", answeredQuestion, totalQuestion))
                    .bold()
                    .font(.title)
            }
            .frame(width: 150)
            
            Rectangle()
                .foregroundStyle(Color.gray)
                .frame(width: 2, height: 80)
                .opacity(0.3)
            
            VStack {
                Text("Elapsed Time")
                    .bold()
                    .font(.subheadline)
                    .opacity(0.3)
                
                Text(formattedTime)
                    .bold()
                    .font(.title)
            }
            .frame(width: 150)
            
        }
        .frame(width: 320, height: 100)
        .background(Color("BackgroundColor"))
        .cornerRadius(10)
    }
}


#Preview {
    ScoreAndTime(
        answeredQuestion: 10,
        totalQuestion: 30,
        formattedTime: "100")
}
