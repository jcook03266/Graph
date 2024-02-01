//
//  3DCoordinate.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import Foundation

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
    
    // MARK: - Display Method
    func toString() -> String {
        return "\(x), \(y), \(z)"
    }
}
