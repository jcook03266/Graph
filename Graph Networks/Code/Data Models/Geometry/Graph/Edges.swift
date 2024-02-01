//
//  Edge.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import Foundation

class Edge {
    // MARK: - Properties
    let v1, v2: Vertex
    /** S*/
    var weight: Float
    
    init(v1: Vertex, v2: Vertex, weight: Float = 0) {
        self.v1 = v1
        self.v2 = v2
        self.weight = weight
    }
}
