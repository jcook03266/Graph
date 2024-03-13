//
//  MainScreenViewModel.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import SwiftUI
import SceneKit
import Combine

class MainScreenViewModel: GenericViewModel {
    // MARK: - Subscriptions
    var cancellables: Set<AnyCancellable> = []
    private let scheduler: DispatchQueue = .main

    // MARK: - Properties
    // Scene Properties
    // Graphical
    @Published var graph: Graph!
 
    // Static
    let coordinateSpace: CoordinateSpace3D = .normalizedCoordinateSpace
    private let testEdges: [Edge] = [
        .init(v1: .init(coordinates: .init(x: 1, y: 2)), v2: .init(coordinates: .init(x: 4, y: 2))),
        .init(v1: .init(coordinates: .init(x: 1, y: 2)), v2: .init(coordinates: .init(x: 4, y: 2))),
        .init(v1: .init(coordinates: .init(x: 4, y: 2)), v2: .init(coordinates: .init(x: 6, y: 8))),
        .init(v1: .init(coordinates: .init(x: 6, y: 8)), v2: .init(coordinates: .init(x: 1, y: 2))),
    ]
    
    // MARK: - Convenience
    var totalEdgeCount: Int {
        return self.graph.edges.count
    }
    
    var totalVertexCount: Int {
        return totalEdgeCount * 2
    }
    
    init() {
        proceduralGraphGenerationFlow()
        addSubscribers()
    }
    
    // MARK: - Subscriptions
    func addSubscribers() {
        // Upstream changes to graph properties 
        self.graph
            .$edges
            .receive(on: scheduler)
            .sink(receiveValue: { _ in
                self.objectWillChange.send()
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Graph Logic
    func proceduralGraphGenerationFlow() {
        self.graph = .randomlyGenerateGraph(
            coordinateSpace: coordinateSpace,
            numEdges: Int.random(in: 1...100)
        )

        printDebugOutput()
    }
    
    func addRandomEdge() {
        self.graph.addEdgeAtRandomPosition(edge: self.graph.generateRandomEdge())
    }
    
    func appendRandomEdge() {
        self.graph.insertEdge(edge: self.graph.generateRandomEdge())
    }
    
    func removeRandomEdge() {
        self.graph.removeRandomEdge()
    }
    
    func removeLastEdge() {
        self.graph.removeLastEdge()
    }
    
    func printDebugOutput() {
        self.graph.adjacencyListToString(aliased: true)
    }
    
    // MARK: - Network Simulation Scripts
    func simpleMovementSimulation() {
        // Move the vertices randomly
        graph.edges = graph.edges.map { edge in
            let stepAmount = 0.1
            let randomMovementFactor = { (input: CGFloat) in
            return input + CGFloat.random(in: -stepAmount...stepAmount)
            }
            
            var targetEdgeVertex = [edge.v1, edge.v2].randomElement()!,
            originalCoordinates = targetEdgeVertex.coordinates,
            updatedCoordinates: Coordinate3D = .init(
                x: randomMovementFactor(originalCoordinates.x),
                y: randomMovementFactor(originalCoordinates.y),
                z: randomMovementFactor(originalCoordinates.z)
            )
            
            // Keep the coordinate points contained within the allotted coordinate space
            if (coordinateSpace.doesPointExistWithin(point: updatedCoordinates)) {
                targetEdgeVertex.updateCoordinates(to: updatedCoordinates)
            }
            
            return edge
        }
        
        // Add or remove some random vertex
        Bool.random() ? addRandomEdge() : removeRandomEdge()
        
        // Trigger update of node positions
        self.objectWillChange.send()
    }
}
