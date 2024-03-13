//
//  CoordinateSpace3D.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import Foundation

class CoordinateSpace3D {
    // MARK: - Properties
    // Static
    let l, r, t, b: Plane3D
    
    // Dynamic
    var planes: [Plane3D] {
        return [l, r, t, b]
    }
    
    init(l: Plane3D, r: Plane3D, t: Plane3D, b: Plane3D) {
        self.l = l
        self.r = r
        self.t = t
        self.b = b
    }
    
    // MARK: - Logic
    private func getBoundariesForDimension(_ dimension: Dimensions3D) -> (max: CGFloat, min: CGFloat) {
        var maxMins: [(max: CGFloat, min: CGFloat)] = []
        
        func getMax(maxMins: [(max: CGFloat, min: CGFloat)]) -> CGFloat {
            return maxMins
                .max(by: { maxMin_1, maxMin_2 in
                    return maxMin_2.max > maxMin_1.max
                })?.max ?? 0
        }
        
        func getMin(maxMins: [(max: CGFloat, min: CGFloat)]) -> CGFloat {
            return maxMins
                .min(by: { maxMin_1, maxMin_2 in
                    return maxMin_2.min < maxMin_1.min
                })?.min ?? 0
        }
        
        switch dimension {
        case .x:
            maxMins = planes.map({ plane in plane.xBoundaries })
        case .y:
            maxMins = planes.map({ plane in plane.yBoundaries })
        case .z:
            maxMins = planes.map({ plane in plane.zBoundaries })
        }
        
        return (max: getMax(maxMins: maxMins), min: getMin(maxMins: maxMins))
    }
    
    func generateRandomPoint() -> Coordinate3D {
        let maxMinX = getBoundariesForDimension(.x),
            maxMinY = getBoundariesForDimension(.y),
            maxMinZ = getBoundariesForDimension(.z)
        
        return .init(x: CGFloat.random(in: maxMinX.min...maxMinX.max),
                     y: CGFloat.random(in: maxMinY.min...maxMinY.max),
                     z: CGFloat.random(in: maxMinZ.min...maxMinZ.max))
    }
    
    // MARK: - Helper Methods
    func doesPointExistWithin(point: Coordinate3D) -> Bool {
        return l.isPointWithinPlane(point: point) &&
        r.isPointWithinPlane(point: point) &&
        t.isPointWithinPlane(point: point) &&
        b.isPointWithinPlane(point: point)
    }
}

extension CoordinateSpace3D {
    /**
     *  Normalized coordinate space (device coordinates 0 -> 1) that ranges between 0 and 1 for all possible dimensions
     *
     *  ```
     *  // Front Face
     * (0, 1, 0) ------- (1, 1, 0)
     *  |                     |
     *  |                     |
     *  |                     |
     * (0, 0, 0) ------- (1, 0, 0)
     *
     *  // Back face
     * (0, 1, 1) ------- (1, 1, 1)
     *  |                     |
     *  |                     |
     *  |                     |
     * (0, 0, 1) ------- (1, 0, 1)
     * ```
     */
    static var normalizedCoordinateSpace: CoordinateSpace3D {
        return .init(l: .normalizedPlane(.left),
                     r: .normalizedPlane(.right),
                     t: .normalizedPlane(.top),
                     b: .normalizedPlane(.bottom))
    }
}
