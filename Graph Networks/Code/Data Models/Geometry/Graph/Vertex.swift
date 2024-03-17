//
//  Point.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import Foundation
import UIKit
import SceneKit

/**
 * A vertex / point is a position in a physical space/coordinate system centered at some exact x, y, and or z position
 */
struct Vertex: Equatable {
    // MARK: - Properties
    var coordinates: Coordinate3D
    
    init(coordinates: Coordinate3D) {
        self.coordinates = coordinates
    }
    
    // MARK: - Protocol Implementation
    static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.coordinates == rhs.coordinates
    }
    
    // MARK: - Transformation Methods
    func toSCNVector(scaledTo size: CGSize = .normalized) -> SCNVector3 {
        let floatVector = coordinates.toFloat()
        
        return SCNVector3(x: Float(size.width) * floatVector.x,
                          y: Float(size.height) * floatVector.y,
                          z: floatVector.z)
    }
    
    func toCGPoint(scaledTo size: CGSize = .normalized) -> CGPoint {
        return .init(x: size.width * coordinates.x, y: size.height * coordinates.y)
    }
    
    mutating func updateCoordinates(to coordinatePoint: Coordinate3D) {
        self.coordinates = coordinatePoint
    }
    
    // MARK: - Helper Methods
    func intersectsWith(vertex: Vertex) -> Bool {
        return GeometryMath.do3DPointsIntersect(point_1: self.coordinates, 
                                                point_2: vertex.coordinates);
    }
}
