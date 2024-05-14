//
//  MenuItem.swift
//  numeratio
//
//  Created by Kristanto Sean on 13/05/24.
//

import SwiftUI

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
    MenuItem(title: "Title", caption: "Caption", image: "globe")
}
