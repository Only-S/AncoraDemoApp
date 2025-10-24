//
//  ContentView.swift
//  Ancora
//
//  Created by Richard Fagundes Rodrigues on 20/10/25.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView: View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {

    func setupAnchor(
        arView: ARView,
        imageName: String,
        model: Entity,
        scale: SIMD3<Float>,
        rotation: simd_quatf,
        position: SIMD3<Float>
    ) {
        let anchor = AnchorEntity(.image(group: "ARResources", name: imageName))
        let clone = model.clone(recursive: true)
        let container = Entity()
        
        container.transform = Transform(scale: scale, rotation: rotation, translation: .zero)
        container.position = position
        
        container.addChild(clone)
        anchor.addChild(container)
        arView.scene.addAnchor(anchor)
    }
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        guard let referenceImages = ARReferenceImage.referenceImages(
            inGroupNamed: "ARResources",
            bundle: nil
        ) else {
            fatalError("ERRO: Não foi possível carregar as imagens de referência do Assets.")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        arView.session.run(configuration)
        
        guard let tecnopuc = try? Entity.load(named: "RetroResearch.usdz") else {
            fatalError("ERRO: Não foi possível carregar 'RetroResearch.usdz'")
        }
        
        let scale = SIMD3<Float>(0.05, 0.05, 0.05)
        let xRotation = simd_quatf(angle: -Float.pi / 2, axis: [1, 0, 0])
        let zRotation = simd_quatf(angle: -Float.pi / 2, axis: [0, 0, 1])
        let combinedRotation = zRotation * xRotation
        let basePosition = SIMD3<Float>(0.0, -0.0, 0.10)

        setupAnchor(arView: arView, imageName: "Tecnopuc", model: tecnopuc,
                    scale: scale,
                    rotation: combinedRotation,
                    position: basePosition)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
