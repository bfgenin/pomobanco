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
    @Binding var placeHolderEditor: String
    
    var placeHolderField: String

    @State var isDisabled: Bool = false
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            TextField(placeHolderField, text: $headline)
                .padding(.leading, 10)
                .overlay (
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(lineWidth: 1)
                        .scale(y: 1.2)
                    
                )
                .overlay (
                    BottomRectangle(width: 300, height: 150, cornerRadius: 24, lineWidth: 1)
                )
            
            ZStack {
                if description.isEmpty && !isDisabled {
                    TextEditor(text: $placeHolderEditor)
                        .padding(.leading, 10)
                        .lineLimit(6)
                        .scrollContentBackground(.hidden)
                        .frame(maxHeight: 120)
                }
                TextEditor(text: $description)
                    .padding(.leading, 10)
                    .lineLimit(6)
                    .scrollContentBackground(.hidden)
                    .frame(maxHeight: 120)
                    .onTapGesture {
                        withAnimation {
                            isDisabled = true
                        }
                    }
                    .onDisappear {
                        isDisabled = false
                    }
            }
            
        }
        .foregroundStyle(color)
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
        
            path.move(to: CGPoint(x: width, y: cornerRadius - 10))
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
            path.addLine(to: CGPoint(x: 0, y: cornerRadius - 10))
        }
        .stroke(lineWidth: lineWidth)
    }
}

#Preview {
    do {
        @State var headline = ""
        @State var description = ""
        
        @State var placeHolderEdtior = "add details here"
        
        var placeHolderField = "add title here "
        
        return stackedTextField(headline: $headline, description: $description, placeHolderEditor: $placeHolderEdtior, placeHolderField: placeHolderField, color: .blue)
    } catch {
        // failed
    }
}
