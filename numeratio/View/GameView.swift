//
//  GameView.swift
//  numeratio
//
//  Created by Christian on 26/04/24.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var currentQuestion: String = ""
    @State private var userInput: String = ""
    @State private var answeredQuestion: Int = 0
    @State private var correctAnswer: Int = 0
    @State private var elapsedTime: Int = 0
    @State private var inputDone: Bool = false
    @State private var gamePaused: Bool = false
    @State private var gameOver: Bool = false
    
    let difficultyLevel: Int
    let selectedOperators: [String]
    let totalQuestion: Int
    
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    private var formattedTime: String {
        let second = elapsedTime / 100
        let minutes = second / 60
        let seconds = second % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScoreAndTime(answeredQuestion: answeredQuestion, totalQuestion: totalQuestion, formattedTime: formattedTime)
                        .padding()
                        .onReceive(timer) { _ in
                            elapsedTime += !(gamePaused || gameOver) ? 1 : 0
                        }
                    Spacer()
                    
                    MainContent(currentQuestion: currentQuestion, userInput: userInput)
                    Spacer()
                    
                    NumPad(userInput: $userInput, inputDone: $inputDone)
                        .onChange(of: inputDone) {
                            if (inputDone) {
                                if (userInput == String(correctAnswer)) {
                                    answeredQuestion += 1
                                    if (answeredQuestion == totalQuestion) {
                                        addAverageSpeed()
                                        gameOver = true
                                    } else {
                                        generateNewQuestion(level: difficultyLevel, operators: selectedOperators)
                                    }
                                } else {
                                    // If answer is false
                                }
                                userInput = ""
                                inputDone = false
                            }
                        }
                }
                .navigationBarTitle("Singleplayer", displayMode: .inline)
                .onAppear{
                    generateNewQuestion(level: difficultyLevel, operators: selectedOperators)
                }
                .fullScreenCover(isPresented: $gamePaused) {
                    PauseView(gamePaused: $gamePaused)
                        .presentationBackground(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
                        .onDisappear {
                            generateNewQuestion(level: difficultyLevel, operators: selectedOperators)
                        }
                }
                .fullScreenCover(isPresented: $gameOver) {
                    GameOverView(gameOver: $gameOver, averageCalculationSpeed: (Double(elapsedTime) / 100) / Double(totalQuestion))
                        .presentationBackground(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
                        .onDisappear {
                            dismiss()
                        }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            gamePaused = true
                        }) {
                            Image(systemName: "pause.fill")
                                .foregroundColor(.cyan)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("< Menu")
                                .foregroundColor(.cyan)
                        }
                    }
                }
            }
        }
    }
    
    func addAverageSpeed() {
        let avgSpeedData = AverageSpeed(date: Date(), level: difficultyLevel, averageSpeed: (Double(elapsedTime) / 100) / Double(totalQuestion))
        context.insert(avgSpeedData)
    }
    
    func generateNewQuestion(level: Int, operators: [String]) {
        var operators = operators
        operators.count == 0 ? operators = ["+"] : ()
        let randomOperator = Int.random(in: 0...operators.count - 1)
        let (min, max): (Int, Int) = {
            switch level {
            case 1:
                return (1, 9)
            case 2:
                return (5, 49)
            case 3:
                return (30, 99)
            case 4:
                return (80, 499)
            case 5:
                return (300, 999)
            default:
                return (1, 999)
            }
        }()

        var randomNumber1: Int = 0
        var randomNumber2: Int = 0
        
        switch operators[randomOperator] {
        case "+":
            correctAnswer = Int.random(in: min...max)
            randomNumber1 = Int.random(in: 0...correctAnswer)
            randomNumber2 = correctAnswer - randomNumber1
            
        case "-":
            correctAnswer = Int.random(in: min...max)
            randomNumber1 = correctAnswer
            randomNumber2 = Int.random(in: 0...randomNumber1)
            correctAnswer = randomNumber1 - randomNumber2
            
        case "×":
            let tempAnswer = {
                var randNum = Int.random(in: min...max)
                while (factors(of: randNum).count < 4) {
                    randNum = Int.random(in: min...max)
                }
                return randNum
            }
            
            correctAnswer = tempAnswer()
            let factor = factors(of: correctAnswer)
            randomNumber1 = factor[Int.random(in: factor.count / 4...factor.count - (factor.count / 4) - 1)]
            randomNumber2 = correctAnswer / randomNumber1
            
        case "÷":
            let tempAnswer = {
                var randNum = Int.random(in: min...max)
                while (factors(of: randNum).count <= level + 1) {
                    randNum = Int.random(in: min...max)
                }
                return randNum
            }
            
            correctAnswer = tempAnswer()
            
            let factor = factors(of: correctAnswer)
            randomNumber1 = correctAnswer
            randomNumber2 = randomNumber1 / factor[Int.random(in: factor.count / 4...factor.count - (factor.count / 4) - 1)]
            correctAnswer = randomNumber1 / randomNumber2
            
        default:
            break
        }
        
        currentQuestion = "\(randomNumber1) \(operators[randomOperator]) \(randomNumber2)"
    }
    
    func factors(of number: Int) -> [Int] {
        var factors: [Int] = []
        
        for i in 1...number {
            if number % i == 0 {
                factors.append(i)
            }
        }
        
        return factors
    }
}

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

struct DailyExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(difficultyLevel: 3, selectedOperators: ["+", "-", "×", "÷"], totalQuestion: 5)
    }
}
