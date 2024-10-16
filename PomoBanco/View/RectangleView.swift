import SwiftUI

struct WrappedTextFieldModifier: ViewModifier {
    var rectangleWidth: CGFloat
    var rectangleHeight: CGFloat
    
    func body(content: Content) -> some View {
        ZStack() {
            AnimateRectangleView(rectangleWidth: rectangleWidth, rectangleHeight: rectangleHeight)
                .opacity(0.5)
            
            content
                .padding(.horizontal, 15)
                .frame(maxWidth: rectangleWidth, maxHeight: rectangleHeight)
                .foregroundStyle(.white)
                .zIndex(1)
        }
    }
}

extension View {
    func wrappedTextFieldStyle(rectangleWidth: CGFloat, rectangleHeight: CGFloat) -> some View {
        self.modifier(WrappedTextFieldModifier(rectangleWidth: rectangleWidth, rectangleHeight: rectangleHeight))
    }
}

struct AnimateRectangleView: View {
    @State private var animate: Bool = false
    
    var rectangleWidth: CGFloat
    var rectangleHeight: CGFloat
    
    var body: some View {
        ZStack {
            //Color.purple.ignoresSafeArea()
            HalfRectangle(animate: animate, color: .white, lineWidth: 2, width: rectangleWidth, height: rectangleHeight, cornerRadius: 25, leftStart: true)
                .opacity(1)
            HalfRectangle(animate: animate, color: .white, lineWidth: 2, width: rectangleWidth, height: rectangleHeight, cornerRadius: 25, leftStart: false)
                .opacity(1)
           
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.4)) {
                animate = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                HalfRectangle(animate: animate, color: .white, lineWidth: 2, width: rectangleWidth, height: rectangleHeight, cornerRadius: 25, leftStart: true)
                    .opacity(0.4)
                
                HalfRectangle(animate: animate, color: .white, lineWidth: 2, width: rectangleWidth, height: rectangleHeight, cornerRadius: 25, leftStart: false)
                    .opacity(1)
                
                }
        }
    }
}

struct HalfRectangle: View {
    var animate: Bool
    var color: Color
    var lineWidth: CGFloat
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    var leftStart: Bool
    
    var body: some View {
        
        Path { path in
            // Calculate the center of the rectangle
            let centerX = width / 2

            
            if leftStart {
                // Start from the center bottom
                path.move(to: CGPoint(x: centerX, y: height))
                
                // LEFT-BOTTOM
                path.addLine(to: CGPoint(x: cornerRadius, y: height))
                path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius),
                            radius: cornerRadius,
                            startAngle: Angle(degrees: 90),
                            endAngle: Angle(degrees: 180),
                            clockwise: false)
                
                // LEFT-TOP
                path.addLine(to: CGPoint(x: 0, y: cornerRadius))
                path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                            radius: cornerRadius,
                            startAngle: Angle(degrees: 180),
                            endAngle: Angle(degrees: 270),
                            clockwise: false)
                
                // CENTER-TOP
                path.addLine(to: CGPoint(x: centerX, y: 0))
                
            } else {
                // Start from the center top
                path.move(to: CGPoint(x: centerX, y: 0))
                
                // RIGHT-TOP EDGE
                path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
                path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius),
                            radius: cornerRadius,
                            startAngle: Angle(degrees: 270),
                            endAngle: Angle(degrees: 360),
                            clockwise: false)
                
                // RIGHT-BOTTOM EDGE
                path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
                path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
                            radius: cornerRadius,
                            startAngle: Angle(degrees: 0),
                            endAngle: Angle(degrees: 90),
                            clockwise: false)
                
                // CENTER-BOTTOM
                path.addLine(to: CGPoint(x: centerX, y: height))
            }
            
        }
        .trim(from: 0, to: animate ? 1 : 0) // Animate from 0 to 1
        .stroke(color, lineWidth: lineWidth)
        .frame(width: width, height: height)
    }
}

struct FullRectanngle : View {
    var animate: Bool
    var color: Color
    var lineWidth: CGFloat
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    
    var body: some View {
        
        Path { path in
            path.move(to: CGPoint(x: width / 2, y: 0))
            
            // top-right arc
            path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
            path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 270),
                        endAngle: Angle(degrees: 360),
                        clockwise: false)
            
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
            path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 180),
                        endAngle: Angle(degrees: 270),
                        clockwise: false)
            
            // Close the path
            path.closeSubpath()
        }
        .trim(from: 0, to: animate ? 1 : 0)
        .stroke(color, lineWidth: lineWidth)
    }
}

#Preview {
    AnimateRectangleView(rectangleWidth: 317, rectangleHeight: 161)
}

//
//path.move(to: CGPoint(x: width / 2, y: 0))
//
//// first-arc: top start
//path.addArc(center: CGPoint(x: isClockWise ? (0+cornerRadius) : (width - cornerRadius), y: cornerRadius),
//            radius: cornerRadius,
//            startAngle: Angle(degrees: 270),
//            endAngle: Angle(degrees: isClockWise ? 180 : 360),
//            clockwise: isClockWise)
//
//// right-bottom arc
//path.addLine(to: CGPoint(x: isClockWise ? 0 : width, y: height - cornerRadius))
//path.addArc(center: CGPoint(x: isClockWise ? (0 + cornerRadius) : (width - cornerRadius), y: height - cornerRadius),
//            radius: cornerRadius,
//            startAngle: Angle(degrees: isClockWise ? -180 : 0),
//            endAngle: Angle(degrees: isClockWise ? -270 : 90),
//            clockwise: isClockWise)


// BOTTOM RIGHT SIDE:

//                    path.addLine(to: CGPoint(x: width - cornerRadius, y: height))
//                    path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
//                                radius: cornerRadius,
//                                startAngle: Angle(degrees: 90),
//                                endAngle: Angle(degrees: 0),
//                                clockwise: true)
//                    path.addLine(to: CGPoint(x: width, y: 0 + cornerRadius))
//                    path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius),
//                                 radius: cornerRadius,
//                                 startAngle: Angle(degrees: 360),
//                                 endAngle: Angle(degrees: 270),
//                                 clockwise: true)
//                    path.addLine(to: CGPoint(x: width / 2, y: 0))
