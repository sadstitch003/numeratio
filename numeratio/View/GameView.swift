//
//  DailyExerciseView.swift
//  numeratio
//
//  Created by Christian on 26/04/24.
//

import SwiftUI

struct GameView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var currentQuestion: String = ""
    @State private var userInput: String = ""
    @State private var answeredQuestion: Int = 0
    @State private var correctAnswer: Int = 0
    @State private var elapsedTime: Int = 0
    @State private var inputDone: Bool = false
    @State private var gamePaused: Bool = false
    @State private var gameOver: Bool = false
    
    let gameLevel: Int
    let operators: [String]
    let totalQuestion: Int
    
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    private var formattedTime: String {
        let second = elapsedTime / 100
        let minutes = second / 60
        let seconds = second % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
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
                                if (answeredQuestion == totalQuestion) {
                                    gameOver = true
                                } else {
                                    answeredQuestion += 1
                                    generateNewQuestion(level: gameLevel, operators: operators)
                                }
                            } else {
                            }
                            
                            userInput = ""
                            inputDone = false
                        }
                    }
            }
            .navigationBarTitle("Daily Exercise", displayMode: .inline)
            .onAppear{
                generateNewQuestion(level: gameLevel, operators: operators)
            }
            .fullScreenCover(isPresented: $gamePaused) {
                PauseView(gamePaused: $gamePaused)
                    .presentationBackground(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
                    .onDisappear {
                        generateNewQuestion(level: gameLevel, operators: operators)
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
            }
        }
    }
    
    func generateNewQuestion(level: Int, operators: [String]) {
        let operators = operators
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
        
        correctAnswer = Int.random(in: min...max)
        
        switch operators[randomOperator] {
        case "+":
            randomNumber1 = Int.random(in: 0...correctAnswer)
            randomNumber2 = correctAnswer - randomNumber1
            
        case "-":
            randomNumber1 = correctAnswer
            randomNumber2 = Int.random(in: 0...randomNumber1)
            correctAnswer = randomNumber1 - randomNumber2
            
        case "×":
            let factor = factors(of: correctAnswer)
            randomNumber1 = factor[Int.random(in: factor.count / 4...factor.count - (factor.count / 4) - 1)]
            randomNumber2 = correctAnswer / randomNumber1
            
        case "÷":
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
        case 0:
            if (userInput.count < 3 && userInput.count > 0) {
                userInput += String(number)
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
        GameView(gameLevel: 3, operators: ["+", "-", "×", "÷"], totalQuestion: 5)
    }
}
