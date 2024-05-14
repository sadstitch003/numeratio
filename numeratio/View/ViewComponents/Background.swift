//
//  Background.swift
//  numeratio
//
//  Created by Kristanto Sean on 13/05/24.
//

import SwiftUI

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

#Preview {
    Background()
}
