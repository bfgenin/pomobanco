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
            .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard))
            .overlay(
                RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard)
                    .stroke(Color.white.opacity(0.1))
            )
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCard())
    }
}
