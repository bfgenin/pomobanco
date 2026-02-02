import SwiftUI
import RealityKit
import simd

struct Tomato: View {
    @State private var root: Entity?
    @State private var isFlipped: Bool = false
    @State private var redMaterial: RealityFoundation.Material?
    @State private var blueMaterial: RealityFoundation.Material?
    @State private var materialProgress: Float = 0.0
    
    var body: some View {
        ZStack {
            if #available(iOS 18.0, *) {
                RealityView { rvcc in
                    rvcc.camera = .virtual
                    
                    do {
                        
                        
                        let rootEntity = try await Entity(named: "tom")
                        
                        // Store reference for animation
                        self.root = rootEntity
                        print("=== Model Hierarchy ===")
                        printEntityHierarchy(rootEntity, level: 0)
                        
                        // Flip the model right-side up
                        rootEntity.transform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
                        
                        if let topCube = rootEntity.findEntity(named: "TopCube") as? ModelEntity,
                           let topMaterial = topCube.model?.materials.first {
                            self.blueMaterial = topMaterial  // Assuming top cube has red material
                            print("✅ Cached red material from TopCube")
                        }
                        
                        if let botCube = rootEntity.findEntity(named: "BotCube") as? ModelEntity,
                           let botMaterial = botCube.model?.materials.first {
                            self.redMaterial = botMaterial  // Assuming bot cube has blue/different material
                            print("✅ Cached blue material from BotCube")
                        }
                        
                        rvcc.add(rootEntity)
                        
                        let light = DirectionalLight()
                        light.light.intensity = 500
                        rvcc.add(light)
                        
                        
                        // Find Cube_001
                        guard let target = rootEntity.findEntity(named: "BotCube") else {
                            print("TopCube not found")
                            return
                        }
                        guard target is ModelEntity else { return }
                        
                        
                        //  Get bounds and calculate proper center
                        let bounds = target.visualBounds(relativeTo: nil)
                        let center = bounds.center
                        let extents = bounds.extents
                        
                        // Calculate distance needed to fit the cube in view
                        let maxDimension = max(extents.x, extents.y, extents.z)
                        let fov: Float = 60
                        let distance = maxDimension / (2 * tan(fov * .pi / 360))
                        
                        // Add some padding
                        let paddedDistance = distance * 3.5
                        self.isFlipped = false
                        
                        if let topCube = rootEntity.findEntity(named: "TopCube"),
                           let botCube = rootEntity.findEntity(named: "BotCube") {
                            changeMaterialColor(entity: topCube, isFlipped: false)
                            changeMaterialColor(entity: botCube, isFlipped: false)
                        }
                        
                        // Create camera
                        let cam = PerspectiveCamera()
                        cam.camera.fieldOfViewInDegrees = Float(fov)
                        
                        // Position camera directly in front of the CENTER
                        cam.position = center + SIMD3<Float>(0, paddedDistance, 0)
                        
                        // Look at the center
                        cam.look(at: center, from: cam.position, relativeTo: nil)
                        
                        
                        rvcc.add(cam)
                        
                    } catch {
                        print("Failed to load entity: \(error)")
                    }
                }
            } else {
                // Fallback on earlier versions
            }
            
            VStack {
                Spacer()
                Button("Rotate Cubes") {
                    rotateCubes()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 50)
            }
        }
    }
    
    func rotateCubes() {
        guard let root = root else { return }
        
        guard let topCube = root.findEntity(named: "TopCube"),
              let botCube = root.findEntity(named: "BotCube") else {
            print("Cubes not found")
            return
        }
        
        // Get current rotation for both cubes
        let topCurrentRotation = topCube.transform.rotation
        let botCurrentRotation = botCube.transform.rotation
        
        // Toggle the flipped state
        isFlipped.toggle()
        
        // Calculate target rotation based on state
        let rotationAngle: Float = isFlipped ? .pi : 0
        let rotationDelta = simd_quatf(angle: rotationAngle, axis: [0, 0, 1])
        
        // Calculate absolute target rotations (not relative)
        let topTargetRotation = rotationDelta
        let botTargetRotation = rotationDelta
        
        // Change material colors
        changeMaterialColor(entity: topCube, isFlipped: isFlipped)
        changeMaterialColor(entity: botCube, isFlipped: isFlipped)
        
        // Create rotation animation for top cube
        let topRotation = FromToByAnimation<Transform>(
            name: "top-rotation",
            from: .init(rotation: topCurrentRotation),
            to: .init(rotation: topTargetRotation),
            duration: 1.2,
            timing: .easeOut,
            bindTarget: .transform
        )
        
        // Create rotation animation for bottom cube
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
        
        // Play top cube animation immediately
        topCube.playAnimation(topAnimationResource)
        
        // Delay bottom cube animation by 0.2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            botCube.playAnimation(botAnimationResource)
        }
    }
    

    func printEntityHierarchy(_ entity: Entity, level: Int) {
        let indent = String(repeating: "  ", count: level)
        print("\(indent)- \(entity.name)")
        
        if let modelEntity = entity as? ModelEntity {
            print("\(indent)  Materials: \(modelEntity.model?.materials.count ?? 0)")
            modelEntity.model?.materials.enumerated().forEach { index, material in
                print("\(indent)    [\(index)]: \(type(of: material))")
            }
        }
        
        for child in entity.children {
            printEntityHierarchy(child, level: level + 1)
        }
    }
    
    func changeMaterialColor(entity: Entity, isFlipped: Bool) {
        guard let modelEntity = entity as? ModelEntity else { return }
        
        if isFlipped {
            // Use red material
            if let blueMaterial = blueMaterial {
                modelEntity.model?.materials = [blueMaterial]
            }
        } else {
            // Use blue material (or create a blue SimpleMaterial if you don't have one)
            if let blueMaterial = redMaterial {
                modelEntity.model?.materials = [blueMaterial]
            }
        }
    }
}
#Preview { Tomato() }
