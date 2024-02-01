//
//  Point.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import Foundation

/**
 * A point is a position in a physical space/coordinate system centered at some exact x, y, and or z position
 */
struct Point {
    // MARK: - Properties
    var coordinates: (x: CGFloat, y: CGFloat, z: CGFloat)
    
    init(coordinates: (x: CGFloat, y: CGFloat, z: CGFloat)) {
        self.coordinates = coordinates
    }
}
