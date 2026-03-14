import SwiftUI
import RealityKit

extension UIColor {
    static let tomatoRed = UIColor(red: 56/255, green: 19/255, blue: 28/255, alpha: 1)
    static let tomatoBlue = UIColor(red: 34/255, green: 15/255, blue: 88/255, alpha: 1)
    

    static func lerp(from: UIColor, to: UIColor, t: CGFloat) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        from.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        to.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(
            red:   r1 + (r2 - r1) * t,
            green: g1 + (g2 - g1) * t,
            blue:  b1 + (b2 - b1) * t,
            alpha: a1 + (a2 - a1) * t
        )
    }
}

struct Tomato: View {
    @State private var root: Entity?
    @Binding var focusMode: Bool
    @State private var redMaterial: RealityFoundation.Material?
    @State private var blueMaterial: RealityFoundation.Material?

    var body: some View {
    
            ZStack {
                if #available(iOS 18.0, *) {
                    RealityView { rvcc in
                        rvcc.camera = .virtual
                        
                        do {
                            let rootEntity = try await Entity(named: "tom")
                            self.root = rootEntity
                            
                        
                            rootEntity.transform.rotation = simd_quatf(angle: .pi, axis: [0, 0, 1])
                            
                            if let topCube = rootEntity.findEntity(named: "TopCube") as? ModelEntity,
                               let topMaterial = topCube.model?.materials.first {
                                self.blueMaterial = topMaterial
                            }
                            
                            if let botCube = rootEntity.findEntity(named: "BotCube") as? ModelEntity,
                               let botMaterial = botCube.model?.materials.first {
                                self.redMaterial = botMaterial
                            }
                            
                            if let topCube = rootEntity.findEntity(named: "TopCube"),
                               let botCube = rootEntity.findEntity(named: "BotCube") {
                                setInitialMaterial(entity: topCube, focusMode: focusMode)
                                setInitialMaterial(entity: botCube, focusMode: focusMode)
                            }
                   
                            
                            rvcc.add(rootEntity)
                                        
                
                            
                            guard let target = rootEntity.findEntity(named: "BotCube") else {
                                print("BotCube not found")
                                return
                            }
                            
                            guard target is ModelEntity else { return }
                            
                            // Preserving original camera block exactly as it was
                            let bounds = target.visualBounds(relativeTo: nil)
                            let center = bounds.center
                            let extents = bounds.extents
                            
                            let maxDimension = max(extents.x, extents.y, extents.z)
                            let fov: Float = 60
                            let distance = maxDimension / (2 * tan(fov * .pi / 360))
                            let paddedDistance = distance * 1.05
                            
                            let cam = PerspectiveCamera()
                            cam.camera.fieldOfViewInDegrees = Float(fov)
                            cam.position = center + SIMD3<Float>(0, paddedDistance, 0)
                            cam.camera.fieldOfViewInDegrees = 300
                            cam.position = center + SIMD3<Float>(0, 5, 0.2)
                            cam.look(at: center, from: cam.position, relativeTo: nil)
                            
                            let redLight = SpotLight()
                            redLight.light.color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
                            redLight.light.intensity = 10000
                            redLight.light.attenuationRadius = 209
                            redLight.light.innerAngleInDegrees = 45
                            redLight.light.outerAngleInDegrees = 90
                            redLight.position = SIMD3<Float>(0, 2, 1.0)
                            redLight.look(at: center, from: redLight.position, relativeTo: nil)
                            rvcc.add(redLight)
                            rvcc.add(cam)
                            
                        } catch {
                            print("Failed to load entity: \(error)")
                        }
                    }
 
                } else {
                    // Fallback on earlier versions
                }
                
            }
        
        
        .onChange(of: focusMode) { _, _ in
            rotateCubes()
        }
        .frame(width: 300, height: 300)
        .clipped()
        .overlay(
            Rectangle()
                .stroke(Color.yellow, lineWidth: 4)
        )

        

    }
    
    func setInitialMaterial(entity: Entity, focusMode: Bool) {
        guard let modelEntity = entity as? ModelEntity else { return }
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: focusMode ? UIColor.tomatoBlue : UIColor.tomatoRed)
        material.metallic = .init(floatLiteral: 1)
        material.roughness = .init(floatLiteral: 0.5)
        modelEntity.model?.materials = [material]
    }
    
    func rotateCubes() {
        guard let root = root else { return }
        
        guard let topCube = root.findEntity(named: "TopCube"),
              let botCube = root.findEntity(named: "BotCube") else {
            print("Cubes not found")
            return
        }
        
        let topCurrentRotation = topCube.transform.rotation
        let botCurrentRotation = botCube.transform.rotation
        
        let rotationAngle: Float = focusMode ? .pi : 0
        let rotationDelta = simd_quatf(angle: rotationAngle, axis: [0, 0, 1])
        
        let topTargetRotation = rotationDelta
        let botTargetRotation = rotationDelta
        
        animateMaterialColor(entity: topCube, focusMode: focusMode)
        animateMaterialColor(entity: botCube, focusMode: focusMode)
        
        let topRotation = FromToByAnimation<Transform>(
            name: "top-rotation",
            from: .init(rotation: topCurrentRotation),
            to: .init(rotation: topTargetRotation),
            duration: 1.2,
            timing: .easeOut,
            bindTarget: .transform
        )
        
        let botRotation = FromToByAnimation<Transform>(
            name: "bot-rotation",
            from: .init(rotation: botCurrentRotation),
            to: .init(rotation: botTargetRotation),
            duration: 1.2,
            timing: .easeOut,
            bindTarget: .transform
        )
        
        let topAnimationResource = try! AnimationResource.generate(with: topRotation)
        let botAnimationResource = try! AnimationResource.generate(with: botRotation)
        
        topCube.playAnimation(topAnimationResource)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            botCube.playAnimation(botAnimationResource)
        }
    }
    
    func animateMaterialColor(entity: Entity, focusMode: Bool) {
        guard let modelEntity = entity as? ModelEntity else { return }
        
        let startColor = focusMode ? UIColor.tomatoRed : UIColor.tomatoBlue
        let endColor = focusMode ? UIColor.tomatoBlue : UIColor.tomatoRed
        
        let duration: TimeInterval = 1.2
        let steps = 60
        let interval = duration / Double(steps)
        
        var currentStep = 0
        
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            currentStep += 1
            let t = Float(currentStep) / Float(steps)
            let clampedT = min(max(t, 0), 1)
            
            let easedT = clampedT < 0.5
                ? 2 * clampedT * clampedT
                : 1 - pow(-2 * clampedT + 2, 2) / 2
            
            let interpolatedColor = UIColor.lerp(from: startColor, to: endColor, t: CGFloat(easedT))
            
            var material = PhysicallyBasedMaterial()
            material.baseColor = .init(tint: interpolatedColor)
            material.metallic = .init(floatLiteral: 1)
            material.roughness = .init(floatLiteral: 0.5)
            modelEntity.model?.materials = [material]
            
            if currentStep >= steps {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    @Previewable @State var focusMode = false
    
    Tomato(focusMode: $focusMode)
      
}
