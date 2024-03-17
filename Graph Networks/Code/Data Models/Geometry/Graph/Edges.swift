//
//  Edge.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import Foundation
import UIKit

/**
 * An edge / link is a connection between two points in a graph / network.
 */
class Edge: Equatable, Hashable, Identifiable {
    // MARK: - Properties
    var v1, v2: Vertex
    
    init(v1: Vertex, v2: Vertex) {
        self.v1 = v1
        self.v2 = v2
    }
    
    // MARK: - Protocol Implementation
    static func == (lhs: Edge, rhs: Edge) -> Bool {
        return lhs.v1 == rhs.v1 && lhs.v2 == rhs.v2
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(v1.coordinates.hashValue)
        hasher.combine(v2.coordinates.hashValue)
    }
    
    // MARK: - Transformation Methods
    func toBezierPath(scaledTo size: CGSize = .normalized) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: v1.toCGPoint(scaledTo: size))
        path.addLine(to: v2.toCGPoint(scaledTo: size))
        
        return path
    }
    
    // MARK: - Helper Methods
    func isConnectedTo(edge: Edge) -> Bool {
        return GeometryMath.areEdgesConnected(edge_1: self, edge2: edge)
    }
    
    // MARK: - Display Methods
    func toString() -> String {
        return "\(self.v1.coordinates.toString()), \(self.v2.coordinates.toString())"
    }
}

/**
 * A weighted edge is an edge with some specified `weight` / value that sets it apart from other edges. This is used
 * in weighted graphs / networks to differentiate pathways from others.
 */
class WeightedEdge: Edge {
    // MARK: - Properties
    let weight: Float
    
    init(v1: Vertex, v2: Vertex, weight: Float) {
        self.weight = weight
        
        super.init(v1: v1, v2: v2)
    }
}
