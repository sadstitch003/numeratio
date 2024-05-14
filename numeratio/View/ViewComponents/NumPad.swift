//
//  NumPad.swift
//  numeratio
//
//  Created by Kristanto Sean on 14/05/24.
//

import SwiftUI

struct NumPad: View {
    @Binding var userInput: String
    @Binding var inputDone: Bool
    
    private let numberPadRows = [
        [7, 8, 9],
        [4, 5, 6],
        [1, 2, 3],
        [-2, 0, -1]
    ]
    
    var body: some View {
        LazyVStack {
            ForEach(numberPadRows, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { number in
                        Button(action: {
                            handleNumberTap(number)
                        }) {
                            if (number == -1) {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.black)
                                    .bold()
                                    .font(.largeTitle)
                                    .frame(width: 100, height: 60)
                                    .background(Color("CustomGreenColor"))
                                    .cornerRadius(8)
                                
                            } else if (number == -2) {
                                Image(systemName: "arrowshape.backward")
                                    .foregroundStyle(Color.black)
                                    .bold()
                                    .font(.largeTitle)
                                    .frame(width: 100, height: 60)
                                    .background(Color("CustomRedColor"))
                                    .cornerRadius(8)
                                
                            } else {
                                Text("\(number)")
                                    .foregroundStyle(Color.black)
                                    .bold()
                                    .font(.largeTitle)
                                    .frame(width: 100, height: 60)
                                    .background(Color("InteractiveColor"))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            
        }
        .frame(height: 360)
    }
    
    private func handleNumberTap(_ number: Int) {
        switch (number) {
        case -1:
            inputDone = true;
        case -2:
            if (userInput.count > 0) {
                userInput.removeLast()
            }
        default:
            if (userInput.count < 3) {
                userInput += String(number)
            }
        }
    }
}


#Preview {
    NumPad(userInput: .constant("20"), inputDone: .constant(false))
}
