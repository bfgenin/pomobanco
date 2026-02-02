//
//  BlurBackground.swift
//  PomoBanco
//
//  Created by Belish Genin on 11/1/24.
//

import SwiftUI

struct BlurBackground: View {
    var body: some View {
        Image(.testScroll)
            .resizable()
            .scaledToFill()
            .scaleEffect(1.01)
            .ignoresSafeArea()

    }
}

#Preview {
    BlurBackground()
}
