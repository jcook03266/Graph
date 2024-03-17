//
//  3DCoordinate.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import Foundation

// MARK: - Enums
/** Represents the different possible coordinate directions / dimensions in a 3 dimensional (3D) space */
enum Dimensions3D: Hashable {
    case x, y, z
}

struct Coordinate3D: Hashable, Comparable {
    // MARK: - Properties
    let x, y, z: CGFloat
    
    init(x: CGFloat, y: CGFloat, z: CGFloat = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    // MARK: - Protocol Implementations
    static func < (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z
    }
    
    static func <= (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool {
        return lhs.x <= rhs.x && lhs.y <= rhs.y && lhs.z <= rhs.z
    }
    
    static func > (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool {
        return lhs.x > rhs.x && lhs.y > rhs.y && lhs.z > rhs.z
    }
    
    static func >= (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool {
        return lhs.x >= rhs.x && lhs.y >= rhs.y && lhs.z >= rhs.z
    }
    
    static func == (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    
    // MARK: - Transformation Methods
    func toFloat() -> (x: Float, y: Float, z: Float) {
        return (x: Float(x), y: Float(y), z: Float(z))
    }
    
    // MARK: - Display Method
    func toString() -> String {
        return "x:\(x), y:\(y), z:\(z)"
    }
}

extension Coordinate3D {
    // MARK: - Front face of a 3D cube
    static var topFrontLeftNormalizedPoint: Coordinate3D {
        return .init(x: 0, y: 1)
    }
    
    static var topFrontRightNormalizedPoint: Coordinate3D {
        return .init(x: 1, y: 1)
    }
    
    static var bottomFrontLeftNormalizedPoint: Coordinate3D {
        return .init(x: 0, y: 0)
    }
    
    static var bottomFrontRightNormalizedPoint: Coordinate3D {
        return .init(x: 1, y: 0)
    }
    
    // MARK: - Back face of a 3D cube
    static var topBackLeftNormalizedPoint: Coordinate3D {
        return .init(x: 0, y: 1, z: 1)
    }
    
    static var topBackRightNormalizedPoint: Coordinate3D {
        return .init(x: 1, y: 1, z: 1)
    }
    
    static var bottomBackLeftNormalizedPoint: Coordinate3D {
        return .init(x: 0, y: 0, z: 1)
    }
    
    static var bottomBackRightNormalizedPoint: Coordinate3D {
        return .init(x: 1, y: 0, z: 1)
    }
}
