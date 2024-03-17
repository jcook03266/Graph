//
//  Collection+Extensions.swift
//  Graph Networks
//
//  Created by Justin Cook on 3/12/24.
//

import Foundation

extension Collection {
  func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
    return Array(self.enumerated())
  }
}
