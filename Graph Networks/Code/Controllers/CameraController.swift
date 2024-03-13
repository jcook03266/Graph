//
//  CameraController.swift
//  Graph Networks
//
//  Created by Justin Cook on 2/1/24.
//

import Foundation
import SceneKit
import SwiftUI

class CameraController: ObservableObject {
    // MARK: - Properties
    @Published var position: SCNVector3
    @Published var zoom: Float
    
    // Defaults
    let defaultPosition: SCNVector3 = .init(x: 0.5, y: 0.5, z: 5),
        defaultZoom: Float = 5
    
    // MARK: - Nodes
    let cameraNode: SCNNode
    
    init(
        initialPosition: SCNVector3? = nil,
        initialZoom: Float? = nil
    ) {
        self.cameraNode = .init()
        self.position = initialPosition ?? defaultPosition
        self.zoom = initialZoom ?? defaultZoom
        
        setup()
    }
    
    // MARK: - Logic
    private func setup() {
        cameraNode.position = position
        cameraNode.name = "cameraNode"
        
        if cameraNode.camera == nil {
            self.cameraNode.camera = SCNCamera()
        }
    }
    
    func update() {
        let updatedPosition: SCNVector3 = .init(
            x: cameraNode.position.x,
            y: cameraNode.position.y,
            z: zoom
        )
     
        position = updatedPosition
    }
    
    // MARK: - Actions
    func updateZoom(by amount: Float) {
        self.zoom += amount
        update()
    }
}
