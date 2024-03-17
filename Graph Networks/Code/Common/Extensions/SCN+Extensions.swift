//
//  SCN+Extensions.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import Foundation
import SceneKit

extension SCNVector3 {
    func distance(to vector: SCNVector3) -> Float {
        let xDistance = vector.x - self.x,
            yDistance = vector.y - self.y,
            zDistance = vector.z - self.z

        return sqrt(xDistance * xDistance + yDistance * yDistance + zDistance * zDistance)
    }
}
