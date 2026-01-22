//
//  MainView.swift
//  PomoBanco
//
//  Created by Belish Genin on 9/25/24.
//

import SwiftUI

// match matchgeometry:
// 1. use on styling/color individual elemnts f
// 2. inidividual elements should keep integritiy of styling, styling before >> match geometry, position after
//
struct MainView: View {
    @Namespace var namespace // state where animatinon exists across multiple/same view
    @State var show = false
    
    var body: some View {
        ZStack {
            if !show {
                VStack(alignment: .leading, spacing: 12) {
                    Text("SwiftUI")
                        .font(.largeTitle.weight(.bold))
                        .matchedGeometryEffect(id: "title", in: namespace)
                        .frame(maxWidth:
                                .infinity, alignment: .leading)
                    Text("20 sections -- 3 hours.".uppercased())
                        .font(.footnote.weight(.semibold))
                        .matchedGeometryEffect(id: "subtitle", in: namespace)
                    Text("This is super cool a lot of text btw, its actually not enough so I added more.")
                        .font(.footnote)
                        .matchedGeometryEffect(id: "text", in: namespace)
                }
                .padding(20)
                .foregroundStyle(.white)
                .background(
                    Color.red.matchedGeometryEffect(id: "background", in: namespace)
                )
                .padding(20)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Spacer()
                    Text("This is super cool a lot of text btw, its actually not enough so I added more.")
                        .font(.footnote)
                        .matchedGeometryEffect(id: "text", in: namespace)
                    Text("20 sections -- 3 hours.".uppercased())
                        .font(.footnote.weight(.semibold))
                        .matchedGeometryEffect(id: "subtitle", in: namespace)
                    Text("SwiftUI")
                        .font(.largeTitle.weight(.bold))
                        .matchedGeometryEffect(id: "title", in: namespace)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(20)
                .foregroundStyle(.black)
                .background(
                    Color.blue.matchedGeometryEffect(id: "background", in: namespace)
                )
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                show.toggle()
            }
        }
    }
}

//#Preview {
//    MainView()
//}
