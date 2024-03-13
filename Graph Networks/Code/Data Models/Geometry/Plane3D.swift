//
//  Plane3D.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import Foundation

// MARK: - Enums
enum Directions {
    case left, right, top, bottom
}

struct Plane3D {
    // MARK: - Properties
    // Static
    let topLeft, topRight, bottomLeft, bottomRight: Coordinate3D
    
    // Computed
    var vertices: [Coordinate3D] {
        return [topLeft, topRight, bottomLeft, bottomRight]
    }
    
    // MARK: - Logic
    var xBoundaries: (max: CGFloat, min: CGFloat) {
        return getMaxMinValueForDimension(.x)
    }
    
    var yBoundaries: (max: CGFloat, min: CGFloat) {
        return getMaxMinValueForDimension(.y)
    }
    
    var zBoundaries: (max: CGFloat, min: CGFloat) {
        return getMaxMinValueForDimension(.z)
    }
    
    private func getMaxMinValueForDimension(_ dimension: Dimensions3D) -> (max: CGFloat, min: CGFloat) {
        var values: [CGFloat] = []
        
        switch dimension {
        case .x:
            values = vertices.map({ vertex in vertex.z })
        case .y:
            values = vertices.map({ vertex in vertex.z })
        case .z:
            values = vertices.map({ vertex in vertex.z })
        }
        
        return getMaxMinValue(values: values)
    }
    
    private func getMaxMinValue(values: [CGFloat]) -> (max: CGFloat, min: CGFloat) {
        return (max: getMaxValue(values: values),
                min: getMinValue(values: values))
    }
    
    private func getMaxValue(values: [CGFloat]) -> CGFloat {
        var maxVal = values[0]
        
        for value in values {
            maxVal = max(maxVal, value)
        }
        
        return maxVal
    }
    
    private func getMinValue(values: [CGFloat]) -> CGFloat {
        var minVal = values[0]
        
        for value in values {
            minVal = min(minVal, value)
        }
        
        return minVal
    }
    
    // MARK: - Helper Methods
    /** True if the point is >= the plane's boundary, false otherwise (outside of the plane i.e less than) */
    func isPointWithinPlane(point: Coordinate3D) -> Bool {
        return GeometryMath.isPointWithinPlane(plane: self, point: point)
    }
    
    // MARK: - Display Methods
    func toString() {
        print(vertices[0].toString(), "------", vertices[1].toString())
        print("|         |")
        print("|         |")
        print("|         |")
        print("|         |")
        print(vertices[2].toString(), "------", vertices[3].toString())
    }
}

extension Plane3D {
    static func normalizedPlane(_ direction: Directions) -> Plane3D {
        switch direction {
        case .left:
            return .init(topLeft: .topFrontLeftNormalizedPoint,
                         topRight: .topBackLeftNormalizedPoint,
                         bottomLeft: .bottomFrontLeftNormalizedPoint,
                         bottomRight: .bottomBackLeftNormalizedPoint)
        case .right:
            return .init(topLeft: .topFrontRightNormalizedPoint,
                         topRight: .topBackRightNormalizedPoint,
                         bottomLeft: .bottomFrontRightNormalizedPoint,
                         bottomRight: .bottomBackRightNormalizedPoint)
        case .top:
            return .init(topLeft: .topBackLeftNormalizedPoint,
                         topRight: .topBackRightNormalizedPoint,
                         bottomLeft: .topFrontLeftNormalizedPoint,
                         bottomRight: .topFrontRightNormalizedPoint)
        case .bottom:
            return .init(topLeft: .bottomBackLeftNormalizedPoint,
                         topRight: .bottomBackRightNormalizedPoint,
                         bottomLeft: .bottomFrontLeftNormalizedPoint,
                         bottomRight: .bottomFrontRightNormalizedPoint)
        }
    }
}
