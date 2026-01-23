//
//  GlassCard.swift
//  PomoBanco
//
//  Created by Belish Genin on 1/22/26.
//

import SwiftUI

struct GlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1))
            )
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCard())
    }
}
//
//#Preview {
//    GlassCard()
//}
