//
//  LinearAlgebra.swift
//  Graph Networks
//
//  Created by Justin Cook on 2/5/24.
//

import Foundation

/**
 * Various linear algebra equations and concepts
 */
class LinearAlgebraMath {
    static func dotProduct(
        vector1: SIMD3<Float>,
        vector2: SIMD3<Float>
    ) -> CGFloat {
        return CGFloat(vector1.x * vector2.x + vector1.y * vector2.y + vector1.z * vector2.z)
    }

    static func crossProduct(
        vector1: SIMD3<Float>,
        vector2: SIMD3<Float>
    ) -> SIMD3<Float> {
        return SIMD3<Float>(
            vector1.y * vector2.z - vector1.z * vector2.y,
            vector1.z * vector2.x - vector1.x * vector2.z,
            vector1.x * vector2.y - vector1.y * vector2.x
        )
    }
    
    static func computeRotationVectorBetween(
        vector1: SIMD3<Float>,
        vector2: SIMD3<Float>
    ) -> SIMD4<Float> {
        // Calculate the direction vector between the two points
        let direction = SIMD3<Float>(
            vector2.x - vector1.x,
            vector2.y - vector1.y,
            vector2.z - vector1.z
        )
        
        // Calculate the distance between the two points
        let distance = sqrt(
            direction.x * direction.x +
            direction.y * direction.y +
            direction.z * direction.z
        )
        
        // Normalize the direction vector
        let normalizedDirection = SIMD3<Float>(
            direction.x / distance,
            direction.y / distance,
            direction.z / distance
        )
        
        // Calculate the angle (in radians) between the two vectors
        let angle = acos(self.dotProduct(
            vector1: normalizedDirection,
            vector2: SIMD3<Float>(0, 1, 0))) // Up vector
        
        // Calculate the axis of rotation (cross product with the up vector)
        let axisOfRotation = self.crossProduct(
            vector1: normalizedDirection,
            vector2: SIMD3<Float>(0, -1, 0)) // - Up vector to flip the rotation vector in the correct direction
        
        return SIMD4<Float>(x: axisOfRotation.x, y: axisOfRotation.y, z: axisOfRotation.z, w: Float(angle))
    }
}
