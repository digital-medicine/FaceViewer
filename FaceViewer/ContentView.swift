//
//  ContentView.swift
//  FaceViewer
//
//  Created by Florian Schweizer on 25.10.23.
//

import SwiftUI
import SceneKit
import SceneKit.ModelIO

// export Array<UIImage> to video:
// https://stackoverflow.com/questions/3741323/how-do-i-export-uiimage-array-as-a-movie

struct PointWithColor {
    let position: SCNVector3
    var color: NSColor = .red
}

let dummyPoints = [
    PointWithColor(position: SCNVector3(x: 0, y: 0, z: 0), color: .red),
    PointWithColor(position: SCNVector3(x: 10, y: 0, z: 0), color: .yellow),
    PointWithColor(position: SCNVector3(x: 100, y: 0, z: 0), color: .orange),
]

struct SceneView: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
        let view = SCNView(frame: NSRect(x: 0, y: 0, width: 300, height: 300))
        let scene = SCNScene()
        view.scene = scene
        
//        for point in dummyPoints {
//            add(point, to: scene)
//        }
        addFromOBJ(named: "head", to: scene)
        
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
    
    private func add(_ point: PointWithColor, to scene: SCNScene) {
        let sphere = SCNSphere(radius: 1)
        sphere.firstMaterial?.diffuse.contents = point.color
//        sphere.firstMaterial?.fillMode = .lines
//        sphere.isGeodesic = true
        
        let node = SCNNode(geometry: sphere)
        node.position = point.position
        scene.rootNode.addChildNode(node)
    }
    
    private func addFromOBJ(named filename: String, to scene: SCNScene) {
        let urlForAsset = Bundle.main.url(forResource: filename, withExtension: "obj")!
        let objAsset = MDLAsset(url: urlForAsset)
        let node = SCNNode(mdlObject: objAsset.object(at: 0))
        node.eulerAngles = SCNVector3Make(0, Double.pi * -0.25, 0)
        node.geometry?.firstMaterial?.fillMode = .lines
        
        let animation = CABasicAnimation(keyPath: "eulerAngles.y")
        animation.fromValue = 0.0
        animation.toValue = 2 * Double.pi
        animation.duration = 5.0
        animation.autoreverses = false
        animation.repeatCount = .infinity
        node.addAnimation(animation, forKey: "rotate-head")
        
        scene.rootNode.addChildNode(node)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            SceneView()
                .frame(width: 300, height: 300)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
