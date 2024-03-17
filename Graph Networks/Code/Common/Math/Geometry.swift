//
//  Geometry.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import Foundation

/**
 * Various geometry related equations and utility methods
 */
class GeometryMath {
    /** True if the 2 points overlap one another (are at the same position), false otherwise */
    static func do3DPointsIntersect(point_1: Coordinate3D, point_2: Coordinate3D) -> Bool {
        return point_1 == point_2
    }
    
    static func isPointWithinPlane(
        plane: Plane3D,
        point: Coordinate3D
    ) -> Bool {
        for vertex in plane.vertices { if point < vertex { return false } }
        return true
    }
    
    static func areEdgesConnected(edge_1: Edge, edge2: Edge) -> Bool {
        return edge_1.v1.intersectsWith(vertex: edge2.v1) ||
        edge_1.v1.intersectsWith(vertex: edge2.v2) ||
        edge_1.v2.intersectsWith(vertex: edge2.v1) ||
        edge_1.v2.intersectsWith(vertex: edge2.v2)
    }
}
