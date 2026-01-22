//
//  BlurBackground.swift
//  PomoBanco
//
//  Created by Belish Genin on 11/1/24.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?

    func makeUIView(context: Context) -> UIVisualEffectView {
        let visualEffectView = UIVisualEffectView()
        visualEffectView.effect = effect
        return visualEffectView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

struct BlurBackground: View {
    var body: some View {
        ZStack {
            Image(.testScroll)
                .resizable()
                .scaledToFit()
                //.frame(maxWidth: .infinity, maxHeight: .infinity)
            // Image(.testScroll)
            //    .blur(radius: 10)
            // Background content
//            VisualEffectView(effect: UIBlurEffect(style: .light))
//                          .cornerRadius(10)
//                          .padding()
//                          .frame(width: 300, height: 200)
//                          .opacity(0.2)
        }
//        .frame(width: 300, height: 300)
        
    }
}

#Preview {
    BlurBackground()
}
