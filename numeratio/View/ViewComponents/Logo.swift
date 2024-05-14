//
//  Logo.swift
//  numeratio
//
//  Created by Kristanto Sean on 13/05/24.
//

import SwiftUI

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

#Preview {
    Logo()
}
