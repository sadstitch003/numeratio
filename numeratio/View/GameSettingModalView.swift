//
//  GameSettingModalView.swift
//  numeratio
//
//  Created by Christian on 03/05/24.
//

import SwiftUI

struct GameSettingModalView: View {
    @Environment(\.dismiss) private var dismiss

    @AppStorage("numberOfQuestion") private var numberOfQuestion: Int = 30
    @AppStorage("difficultyLevel") private var difficultyLevel: Int = 3
    
    @AppStorage("additionOperator") private var additionOperator: Bool = true
    @AppStorage("subtractionOperator") private var subtractionOperator: Bool = true
    @AppStorage("divisionOperator") private var divisionOperator: Bool = true
    @AppStorage("multiplicationOperator") private var multiplicationOperator: Bool = true
    
    @State private var startGame: Bool = false
    
    var selectedOperators: [String] {
        var operators: [String] = []
        if additionOperator { operators.append("+") }
        if subtractionOperator { operators.append("-") }
        if multiplicationOperator { operators.append("×") }
        if divisionOperator { operators.append("÷") }
        return operators
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Arithmetic Operations")) {
                        Toggle("Addition", isOn: $additionOperator)
                        Toggle("Subtraction", isOn: $subtractionOperator)
                        Toggle("Division", isOn: $divisionOperator)
                        Toggle("Multiplication", isOn: $multiplicationOperator)
                    }
                    
                    Section(header: Text("Game Configuration")) {
                        Picker("Number of Questions", selection: $numberOfQuestion) {
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
        .fullScreenCover(isPresented: $startGame) {
            GameView(
                difficultyLevel: difficultyLevel,
                selectedOperators: selectedOperators,
                totalQuestion: numberOfQuestion
            )
        }
    }
}

#Preview {
    GameSettingModalView()
}
