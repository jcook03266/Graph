//
//  Graph.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import Foundation

class Graph: ObservableObject {
    // MARK: - Properties
    // Input
    @Published var edges: [Edge]
    
    // Dynamic
    var adjacentEdges: [Edge: [Edge]] = [:]
    
    init(edges: [Edge]) {
        self.edges = edges
        buildAdjacencyList()
    }
    
    // MARK: - Logic
    func insertEdge(edge: Edge) {
        edges.append(edge)
        
        // Rebuild the adjacency list
        buildAdjacencyList()
    }
    
    func addEdgeAtRandomPosition(edge: Edge) {
        if (edges.count > 0) {
            edges.insert(edge, at: Int.random(in: 0..<edges.count))
        }
        else {
            insertEdge(edge: edge)
        }
    }
    
    func removeRandomEdge() {
        if edges.count <= 0 { return }
        
        edges.remove(at: Int.random(in: 0..<edges.count))
    }
    
    func removeLastEdge() {
        if edges.count <= 0 { return }
        
        edges.removeLast()
        
        // Rebuild the adjacency list
        buildAdjacencyList()
    }
    
    func generateRandomEdge(
        coordinateSpace: CoordinateSpace3D = .normalizedCoordinateSpace) -> Edge {
            let vertices: [Vertex] = [
                Vertex(coordinates: coordinateSpace.generateRandomPoint()),
                Vertex(coordinates: coordinateSpace.generateRandomPoint())
            ]
            
            // Get the some random already generated edge from the graph
            let existingEdge: Edge? = self.edges.randomElement(),
                connectedVertex = existingEdge != nil ? vertices.first { vertex in
                    guard let lastEdge = existingEdge else { return false }
                    
                    return vertex.intersectsWith(vertex: lastEdge.v1) ||
                    vertex.intersectsWith(vertex: lastEdge.v2)
                } ?? existingEdge?.v2 : nil
            
            // Vertices, at least one vertex has to be connected to another past vertex
            // (preferably v2 (existing) to v1 (current)
            let vertex_1: Vertex = connectedVertex ?? vertices[0],
                vertex_2: Vertex = vertices[1]
            
            return Edge(v1: vertex_1,
                        v2: vertex_2)
    }
    
    func rebuild() {
        buildAdjacencyList()
    }
    
    private func buildAdjacencyList() {
        self.adjacentEdges.removeAll()
        
        for x in 0..<edges.count {
            let edge_1 = edges[x]
            
            for y in (x + 1 )..<edges.count {
                let edge_2 = edges[y]
                
                // Determine if the edges are connected
                let edgesConnected = edge_1.isConnectedTo(edge: edge_2) && edge_1 != edge_2,
                    alreadyAdjacent = (adjacentEdges[edge_1]?.contains(where: { $0 == edge_2 }) ?? false) == true || (adjacentEdges[edge_2]?.contains(where: { $0 == edge_2 }) ?? false) == true
                 
                // Connected and not yet marked as adjacent, insert into adjacency list
                if edgesConnected && !alreadyAdjacent {
                    if (self.adjacentEdges[edge_1] ?? []).isEmpty { self.adjacentEdges[edge_1] = [edge_2] }
                    else { self.adjacentEdges[edge_1]!.append(edge_2) }
                }
            }
        }
    }
    
    static func randomlyGenerateGraph(
        coordinateSpace: CoordinateSpace3D = .normalizedCoordinateSpace,
        numEdges: Int = 4) -> Graph {
            var edges: [Edge] = []
            
            for index in 0..<numEdges {
                let vertices: [Vertex] = [Vertex(coordinates: coordinateSpace.generateRandomPoint()),
                                          Vertex(coordinates: coordinateSpace.generateRandomPoint())]
                
                // Get the some random already generated edge from the graph
                let existingEdge: Edge? = index > 0 ? edges.randomElement() : nil,
                    connectedVertex = existingEdge != nil ? vertices.first { vertex in
                        guard let lastEdge = existingEdge else {
                            return false }
                        
                        return vertex.intersectsWith(vertex: lastEdge.v1) ||
                        vertex.intersectsWith(vertex: lastEdge.v2)
                    } ?? existingEdge?.v2 : nil
                
                // Vertices, at least one vertex has to be connected to another past vertex
                // (preferably v2 (existing) to v1 (current)
                let vertex_1: Vertex = connectedVertex ?? vertices[0],
                    vertex_2: Vertex = vertices[1]
                
                edges.append(Edge(v1: vertex_1, v2: vertex_2))
            }
            
            return .init(edges: edges)
    }
    
    // MARK: - Display Methods
    /**
     *  - Parameters:
     *      - aliased: True if edges should be identified by a simplified aliased 
     */
    func adjacencyListToString(aliased: Bool = false) {
        for adjacency in adjacentEdges {
            let primaryEdge = adjacency.key,
                connectedEdges = adjacency.value
    
            print(aliased ? primaryEdge.hashValue.description : primaryEdge.toString(), "--->",
                  connectedEdges.map({ edge in aliased ? edge.hashValue.description : edge.toString() }))
        }
    }
}
