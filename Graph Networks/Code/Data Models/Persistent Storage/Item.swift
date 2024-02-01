//
//  Item.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
