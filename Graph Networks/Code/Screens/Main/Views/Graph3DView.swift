//
//  Graph3DView.swift
//  Graph Networks
//
//  Created by Justin Cook on 2/1/24.
//

import SwiftUI
import SceneKit

struct Graph3DView: UIViewRepresentable {
    // MARK: - Observed
    @ObservedObject var cameraController: CameraController
    
    // MARK: - Data
    let graph: Graph
    
    // MARK: - Graphical Properties
    @Binding var connectorGeometry: ConnectorGeometry
    @Binding var nodeConnectorThickness: CGFloat
    @Binding var connectorColor: CGColor
    
    enum ConnectorGeometry {
        case none, dimensions_2, dimensions_3
    }
    
    // MARK: - Animation Properties
    @Binding var animationDuration: CGFloat
    
    // MARK: - Properties
    @State var scene: SCNScene = .init()
    
    // MARK: - Protocol Implementation
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = scene
        sceneView.backgroundColor = .white
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.pointOfView = cameraController.cameraNode
        sceneView.antialiasingMode = .multisampling4X
        
        // Update / add the camera to the scene
        scene.rootNode.addChildNode(cameraController.cameraNode)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.pointOfView = cameraController.cameraNode
        
        updateScene()
    }
    
    private func removeUnusedNodes(excluding nodesToExclude: [SCNNode] = []) {
        scene.rootNode.enumerateChildNodes { (node, _) in
            let isExcluded = nodesToExclude
                .contains { excludedNode in
                    excludedNode.name == node.name
                }
            
            // Remove the node and stop all renders for it
            if (!isExcluded) {
                node.removeAllActions()
                node.removeAllAnimations()
                node.removeFromParentNode()
            }
        }
    }
    
    // Function to update node positions
    private func updateScene() {
        var nodesToKeep: [SCNNode] = []
        
        // Camera node is required
        guard let cameraNode = scene.rootNode.childNode(withName: "cameraNode", recursively: true)
        else { return }
        
        SCNTransaction.begin()
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        nodesToKeep.append(cameraNode)
        
        for (index, edge) in graph.edges.enumerated() {
            // Connector Nodes
            let lineNode = scene.rootNode
                .childNode(withName: "line-\(index)-\(connectorColor)-\(nodeConnectorThickness)", recursively: true),
                tubeNode = scene.rootNode
                .childNode(withName: "tube-\(index)-\(connectorColor)-\(nodeConnectorThickness)", recursively: true),
                connectorNode = connectorGeometry == .dimensions_3 ? tubeNode :
            (connectorGeometry == .dimensions_2 ? lineNode : nil)
            
            // Get node references
            // Vertex Nodes
            guard let node1 = scene.rootNode.childNode(withName: "node-\(index * 2)", recursively: true),
                  let node2 = scene.rootNode.childNode(withName: "node-\(index * 2 + 1)", recursively: true),
                  (connectorGeometry == .none && connectorNode != nil) == false,
                  (connectorGeometry == .dimensions_2 && lineNode == nil) == false,
                  (connectorGeometry == .dimensions_3 && tubeNode == nil) == false
            else {
                // Nodes don't exist yet, create them and
                // then continue on to the existing nodes that need to be updated
                
                // Generate nodes
                let node1 = SCNNode(
                    geometry: SCNBox(
                        width: 0.05,
                        height: 0.05,
                        length: 0.05,
                        chamferRadius: 10
                    )),
                    node2 = SCNNode(
                        geometry: SCNBox(
                            width: 0.05,
                            height: 0.05,
                            length: 0.05,
                            chamferRadius: 10
                        ))
                
                // Set node positions
                node1.position = edge.v1.toSCNVector()
                node2.position = edge.v2.toSCNVector()
                
                // Name vertex nodes for later reference
                node1.name = "node-\(index * 2)"
                node2.name = "node-\(index * 2 + 1)"
                
                // Add nodes to scene
                scene.rootNode.addChildNode(node1)
                scene.rootNode.addChildNode(node2)
                
                nodesToKeep.append(node1)
                nodesToKeep.append(node2)
                
                // Create connector nodes
                let vector1 = node1.position,
                    vector2 = node2.position
                
                guard connectorGeometry != .none
                else { continue }
                
                let line = SCNNode.lineFrom(
                    vector1: vector1,
                    vector2: vector2),
                    tube = SCNNode.tubeFrom(
                        vector1: vector1,
                        vector2: vector2,
                        thickness: nodeConnectorThickness,
                        color: UIColor(cgColor: connectorColor)
                    )
                
                // Name connector nodes for later reference
                line.name = "line-\(index)-\(connectorColor)-\(nodeConnectorThickness)"
                tube.name = "tube-\(index)-\(connectorColor)-\(nodeConnectorThickness)"
                
                if (connectorGeometry == .dimensions_3) {
                    scene.rootNode.addChildNode(tube)
                    nodesToKeep.append(tube)
                }
                else if (connectorGeometry == .dimensions_2) {
                    scene.rootNode.addChildNode(line)
                    nodesToKeep.append(line)
                }
                
                continue
            }
            
            // Updated vertex positions
            let vector1 = edge.v1.toSCNVector(),
                vector2 = edge.v2.toSCNVector()
        
            // Animate node positions
            let moveNode1Action = SCNAction.move(to: vector1,
                                                 duration: animationDuration),
                moveNode2Action = SCNAction.move(to: vector2,
                                                 duration: animationDuration)
            
            node1.runAction(moveNode1Action)
            node2.runAction(moveNode2Action)
            
            // Persist updated nodes
            nodesToKeep.append(node1)
            nodesToKeep.append(node2)
            
            guard let connectorNode = connectorNode
            else { return }
            
            // Animate connector position and rotation
            var connectorNodePosition: SCNVector3 = connectorNode.position,
                connectorRotation: SCNVector4 = connectorNode.rotation
            
            if (tubeNode != nil) {
                let updatedTube = SCNNode.tubeFrom(
                    vector1: vector1,
                    vector2: vector2,
                    thickness: nodeConnectorThickness,
                    color: UIColor(cgColor: connectorColor)
                )
                
                connectorNodePosition = updatedTube.position
                connectorRotation = updatedTube.rotation
                
                connectorNode.geometry = updatedTube.geometry
            }
            else if (lineNode != nil) {
                let updatedLine = SCNNode.lineFrom(
                    vector1: vector1,
                    vector2: vector2)
                
                connectorNodePosition = updatedLine.position
                connectorRotation = updatedLine.rotation
                
                connectorNode.geometry = updatedLine.geometry
            }
            
            let moveConnectorNodeAction = SCNAction.move(
                to: connectorNodePosition,
                duration: animationDuration
            ),
                rotateConnectorNodeAction = SCNAction.rotate(
                    toAxisAngle: connectorRotation,
                    duration: animationDuration
                )

            
            connectorNode.runAction(moveConnectorNodeAction)
            connectorNode.runAction(rotateConnectorNodeAction)
            
            nodesToKeep.append(connectorNode)
        }
        
        // Camera actions
        let updatedCameraPosition = cameraController.position
        
        let cameraPositionAction = SCNAction.move(
            to: updatedCameraPosition,
            duration: 1
        )
        
        cameraNode.runAction(cameraPositionAction)
        
        // Commit all animation transactions
        SCNTransaction.commit()
        
        // Garbage collection
        removeUnusedNodes(excluding: nodesToKeep)
    }
}

// MARK: - Line Node / Geometry
extension SCNNode {
    static func lineFrom(vector1: SCNVector3, vector2: SCNVector3) -> SCNNode {
        let indices: [UInt32] = [0, 1],
            source = SCNGeometrySource(
                vertices: [vector1, vector2])
        
        let element = SCNGeometryElement(
            indices: indices,
            primitiveType: .line
        ),
            geometry = SCNGeometry(
                sources: [source],
                elements: [element]
            )
        
        return SCNNode(geometry: geometry)
    }
}

// MARK: - Tube Node / Geometry
extension SCNNode {
    static func tubeFrom(
        vector1: SCNVector3,
        vector2: SCNVector3,
        thickness: CGFloat,
        color: UIColor
    ) -> SCNNode {
        let length = vector1.distance(to: vector2),
            cylinder = SCNCylinder(
                radius: thickness / 2.0,
                height: CGFloat(length)
            )
        
        let tubeNode = SCNNode(geometry: cylinder)
        
        // Set position & orientation of the tube
        tubeNode.position = SCNVector3(
            (vector1.x + vector2.x) / 2,
            (vector1.y + vector2.y) / 2,
            (vector1.z + vector2.z) / 2
        )
        
        tubeNode.rotation = SCNVector4(
            LinearAlgebraMath.computeRotationVectorBetween(
            vector1: SIMD3<Float>(vector1),
            vector2: SIMD3<Float>(vector2)
        ))
        
        // Customize the material/color
        tubeNode.geometry?.firstMaterial?.diffuse.contents = color
        tubeNode.geometry?.firstMaterial?.isDoubleSided = true
        
        return tubeNode
    }
}
