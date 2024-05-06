//
//  GameSettingModalView.swift
//  numeratio
//
//  Created by Christian on 03/05/24.
//

import SwiftUI

struct GameSettingModalView: View {
    @Environment(\.dismiss) private var dismiss
     
    @State var numberOfQuestion: Int = 30
    @State var difficultyLevel: Int = 3
    
    @State var additionOperator: Bool = true
    @State var subtractionOperator: Bool = true
    @State var divisionOperator: Bool = true
    @State var multiplicationOperator: Bool = true
    
    @State var startGame: Bool = false
    
    var selectedOperators: [String] {
        var operators: [String] = []
        additionOperator ? operators.append("+") : ()
        subtractionOperator ? operators.append("-") : ()
        multiplicationOperator ? operators.append("×") : ()
        divisionOperator ? operators.append("÷") : ()
        return operators
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Arithmetic Operations")) {
                        Toggle(isOn: $additionOperator) {
                            Text("Addition")
                        }
                        Toggle(isOn: $subtractionOperator) {
                            Text("Subtraction")
                        }
                        Toggle(isOn: $divisionOperator) {
                            Text("Division")
                        }
                        Toggle(isOn: $multiplicationOperator) {
                            Text("Multiplication")
                        }
                    }
                    
                    Section(header: Text("Game Configuration")) {
                        Picker("Number of Question", selection: $numberOfQuestion) {
                            Text("5").tag(5)
                            Text("20").tag(20)
                            Text("30").tag(30)
                            Text("50").tag(50)
                        }
                        
                        Picker("Difficulty Level", selection: $difficultyLevel) {
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("3").tag(3)
                            Text("4").tag(4)
                            Text("5").tag(5)
                        }
                    }
                    
                    Button("Start") {
                        startGame = true
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationBarTitle("Game Setting")
        }
        .fullScreenCover(isPresented: $startGame, content: {
            GameView(difficultyLevel: difficultyLevel, selectedOperators: selectedOperators, totalQuestion: numberOfQuestion)
                .onDisappear {
                    dismiss()
                }
        })
    }
}

#Preview {
    GameSettingModalView()
}
