//
//  Classification.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 30/09/23.
//

import Foundation

class Classification {
  let name: String
  let confidence: Float
  
  init(name: String, confidence: Float) {
    self.name = name
    self.confidence = confidence
  }
}

extension Classification: CustomStringConvertible {
  var description: String {
    get {
      return "\(name), \(confidence)"
    }
  }
}
