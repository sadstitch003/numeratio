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
                    
//                    MenuItem(
//                        title: "Multiplayer",
//                        caption: "Compete for precision and speed",
//                        image: "text.magnifyingglass"
//                    )
                  
                    NavigationLink (destination: GameHistory()) {
                        MenuItem(
                            title: "History",
                            caption: "Analyze your counting speed history",
                            image: "person.2"
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

struct Background: View {
    var body: some View {
        GeometryReader{ geometry in
            Circle()
                .size(width: geometry.size.width * 2, height: geometry.size.width * 2)
                .fill(Color("BackgroundColor"))
                .position(y: -(geometry.size.height / 2.5))
        }
    }
}

struct Logo: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Image(colorScheme == .dark ? "LogoDark" : "LogoLight")
            .resizable()
            .frame(width: 160, height: 160)
            .padding()
            .padding(.top, 20)
    }
}

struct MenuItem: View {
    let title: String
    let caption: String
    let image: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
                .padding(.trailing, 8)
                .foregroundStyle(Color.black)
            
            VStack {
                HStack {
                    Text(title)
                        .foregroundStyle(Color.black)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                HStack {
                    Text(caption)
                        .foregroundStyle(Color.black)
                        .font(.caption)
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(width: 320, height: 40)
        .padding()
        .background(Color("InteractiveColor"))
        .cornerRadius(8)
    }
}

#Preview {
    ContentView()
}
