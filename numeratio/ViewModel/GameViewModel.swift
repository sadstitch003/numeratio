//
//  GameViewModel.swift
//  numeratio
//
//  Created by Kristanto Sean on 13/05/24.
//

import Foundation
import SwiftData

@Observable class GameViewModel {
    
    var context: ModelContext? = nil
    
    var currentQuestion: String = ""
    var userInput: String = ""
    var answeredQuestion: Int = 0
    var correctAnswer: Int = 0
    var elapsedTime: Int = 0
    var inputDone: Bool = false
    var gamePaused: Bool = false
    var gameOver: Bool = false
    
    var difficultyLevel: Int = 0
    var totalQuestion: Int = 0
    var selectedOperators: [String] = []
    
    func addAverageSpeed() {
        guard let context = context else {
            return
        }
        
        let avgSpeedData = AverageSpeed(
            date: Date(),
            level: difficultyLevel,
            averageSpeed: getCalculationSpeed()
        )
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
                while (self.factors(of: randNum).count < 4) {
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
                while (self.factors(of: randNum).count <= level + 1) {
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
    
    func checkInputDone() {
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
    
    func getCalculationSpeed() -> Double {
        return (Double(elapsedTime) / 100) / Double(totalQuestion)
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
