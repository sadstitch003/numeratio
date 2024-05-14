//
//  ContentView.swift
//  numeratio
//
//  Created by Christian on 25/04/24.
//

import SwiftUI


struct ContentView: View {
    @State var showGameSetting: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Background()
                
                VStack {
                    Logo()
                    
                    MenuItem(
                        title: "Singleplayer",
                        caption: "Customize exercise to enhance your skills",
                        image: "person"
                    )
                    .onTapGesture {
                        showGameSetting = true
                    }
                    .sheet(isPresented: $showGameSetting, content: {
                        GameSettingModalView()
                            .presentationDetents([.fraction(0.7)])
                    })
                    
                    MenuItem(
                        title: "Multiplayer",
                        caption: "Compete for precision and speed",
                        image: "person.2"
                    )
                    .disabled(true)
                    .opacity(0.5)
                  
                    NavigationLink (destination: GameHistoryView()) {
                        MenuItem(
                            title: "History",
                            caption: "Analyze your counting speed history",
                            image: "text.magnifyingglass"
                        )
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Menu")
            .toolbar(.hidden)
        }
        .tint(Color.cyan)
    }
}



#Preview {
    ContentView()
}
