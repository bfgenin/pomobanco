import SwiftUI
struct RectangleView: View {
    var text: String
    @State private var animate: Bool = false
    @State private var secondAnimate: Bool = false
    @State private var visible: Bool = true
    var rectangleWidth: CGFloat = 333
    var rectangleHeight: CGFloat = 48

    var body: some View {
        VStack {
            Spacer() // Center vertically

            ZStack {
                Color.purple.ignoresSafeArea()

                // First rectangle
                RectangleSingle(animate: animate, color: .white, lineWidth: 10, width: rectangleWidth, height: rectangleHeight)
                    .opacity(1)

                // Second rectangle with a delay
                if visible {
                    RectangleSingle(animate: secondAnimate, color: .white, lineWidth: 10, width: rectangleWidth, height: rectangleHeight)
                        .opacity(secondAnimate ? 0.8 : 0) // Control opacity with secondAnimate
                        .blur(radius: 10)
                }
                Text(text)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
            }
            .offset(x: 40, y: -20)
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Take full space

            Spacer() // Center vertically
        }
        .background(.purple)
        .onAppear {
            // Start the animation for the first rectangle
            withAnimation(.linear(duration: 1.5)) {
                animate = true
            }
            
            // Start the animation for the second rectangle after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.linear(duration: 1.5)) {
                    secondAnimate = true
                }
                
                // Ease out effect after the second rectangle is visible
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    withAnimation(.easeOut(duration: 1)) {
                        visible = false
                    }
                }
            }
        }
    }
}

struct RectangleSingle: View {
    var animate: Bool
    var color: Color
    var lineWidth: CGFloat
    var width: CGFloat
    var height: CGFloat

    var body: some View {
        Path { path in
            let cornerRadius: CGFloat = 40
            
            // Start at the top-left corner
            path.move(to: CGPoint(x: cornerRadius, y: 0))
            
            // Top edge
            path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
            
            // Top-right corner
            path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 270),
                        endAngle: Angle(degrees: 360),
                        clockwise: false)
            
            // Right edge
            path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
            
            // Bottom-right corner
            path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 90),
                        clockwise: false)
            
            // Bottom edge
            path.addLine(to: CGPoint(x: cornerRadius, y: height))
            
            // Bottom-left corner
            path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 90),
                        endAngle: Angle(degrees: 180),
                        clockwise: false)
            
            // Left edge
            path.addLine(to: CGPoint(x: 0, y: cornerRadius))
            
            // Top-left corner
            path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 180),
                        endAngle: Angle(degrees: 270),
                        clockwise: false)

            // Close the path
            path.closeSubpath()
        }
        .trim(from: 0, to: animate ? 1 : 0) // Animate from 0 to 1
        .stroke(color, lineWidth: lineWidth)
    }
}

#Preview {
    RectangleView(text: "Hello World!", rectangleWidth: 250, rectangleHeight: 250)
}
