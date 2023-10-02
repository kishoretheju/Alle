//
//  Classification.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 30/09/23.
//

import Foundation
import RealmSwift

class Classification: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  
  @Persisted var name: String
  @Persisted var confidence: Float
  
  convenience init(name: String, confidence: Float) {
    self.init()
    self.name = name
    self.confidence = confidence
  }
}
