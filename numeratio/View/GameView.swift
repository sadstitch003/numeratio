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
    
    @State private var viewModel = GameViewModel()
    
    let difficultyLevel: Int
    let selectedOperators: [String]
    let totalQuestion: Int
    
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    private var formattedTime: String {
        let second = viewModel.elapsedTime / 100
        let minutes = second / 60
        let seconds = second % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScoreAndTime(
                        answeredQuestion: viewModel.answeredQuestion,
                        totalQuestion: totalQuestion,
                        formattedTime: formattedTime
                    )
                        .padding()
                        .onReceive(timer) { _ in
                            viewModel.elapsedTime += !(viewModel.gamePaused || viewModel.gameOver) ? 1 : 0
                        }
                    
                    Spacer()
                    
                    MainContent(
                        currentQuestion: viewModel.currentQuestion,
                        userInput: viewModel.userInput
                    )
                    
                    Spacer()
                    
                    NumPad(
                        userInput: $viewModel.userInput,
                        inputDone: $viewModel.inputDone
                    )
                    .onChange(of: viewModel.inputDone) {
                        viewModel.checkInputDone()
                    }
                }
                .navigationBarTitle("Singleplayer", displayMode: .inline)
                .onAppear{
                    viewModel.generateNewQuestion(
                        level: difficultyLevel,
                        operators: selectedOperators
                    )
                }
                .fullScreenCover(isPresented: $viewModel.gamePaused) {
                    PauseView(
                        gamePaused: $viewModel.gamePaused
                    )
                    .presentationBackground(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
                    .onDisappear {
                        viewModel.generateNewQuestion(
                            level: difficultyLevel,
                            operators: selectedOperators
                        )
                    }
                }
                .fullScreenCover(isPresented: $viewModel.gameOver) {
                    GameOverView(
                        gameOver: $viewModel.gameOver,
                        averageCalculationSpeed: viewModel.getCalculationSpeed()
                    )
                    .presentationBackground(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
                    .onDisappear {
                        dismiss()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.gamePaused = true
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
            .onAppear {
                viewModel.difficultyLevel = difficultyLevel
                viewModel.selectedOperators = selectedOperators
                viewModel.totalQuestion = totalQuestion
                viewModel.context = context
            }
        }
    }
    
}


struct DailyExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(
            difficultyLevel: 3,
            selectedOperators: ["+", "-", "×", "÷"],
            totalQuestion: 5
        )
    }
}
