//
//  Background.swift
//  PomoBanco
//
//  Created by Belish Genin on 11/18/24.
//

import SwiftUI

struct Background: View {
    var body: some View {
        LinearGradient(
                  gradient: Gradient(
                      stops: [
                        .init(color: .darkPink, location: 0.0),
                        .init(color: .darkPink, location: 0.70),
                        .init(color: .medPink, location: 0.95),
                        .init(color: .lightPink, location: 1.0)
                      ]
                  ),
                  startPoint: .top,
                  endPoint: .bottom
              )
        .ignoresSafeArea()
              
    }
}

#Preview {
    Background()
}
