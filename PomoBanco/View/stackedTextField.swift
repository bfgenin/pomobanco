//
//  stackedTextField.swift
//  PomoBanco
//
//  Created by Belish Genin on 10/7/24.
//

import SwiftUI

struct stackedTextField: View {
    @Binding var headline: String
    @Binding var description: String
    
    var body: some View {
        ZStack {
            
            TextField("", text: $headline)
                .padding(.leading, 10)
                .overlay (
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(lineWidth: 1)
                )
            
            TextField("hello", text: $description)
                .padding(.leading, 10)
                .padding(.top, 20)
                .frame(height: 200)
                .overlay (
                    BottomRectangle(width: 300, height: 150, cornerRadius: 24, lineWidth: 1)
                        .offset(y: 60)
                )
                .offset(CGSize(width: 0, height: 20))
            
        }
        .frame(width: 300)
    }
}

struct BottomRectangle: View {
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    var lineWidth: CGFloat
    
    var body: some View {
        
        Path { path in
        
            path.move(to: CGPoint(x: width, y: cornerRadius))
            // right-bottom arc
            path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
            path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 90),
                        clockwise: false)
            // left-bottom arc
            path.addLine(to: CGPoint(x: cornerRadius, y: height))
            path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 90),
                        endAngle: Angle(degrees: 180),
                        clockwise: false)
            
            // Left edge
            path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        }
        .stroke(lineWidth: lineWidth)
    }
}

#Preview {
    do {
        @State var headline = "add title here"
        @State var description = "add description here"
        
        return stackedTextField(headline: $headline, description: $description)
    } catch {
        // failed
    }
}
