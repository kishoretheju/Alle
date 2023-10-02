//
//  ImageEntity.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 29/09/23.
//

import Foundation
import UIKit
import VisionKit
import Vision
import RealmSwift

class ImageEntity: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var name: String
  @Persisted var creationDate = Date()
  @Persisted var ocrTexts = List<String>()
  @Persisted var classifications = List<Classification>()
  @Persisted var notes: String? = nil
  
  convenience init(name: String) {
    self.init()
    self.name = name
  }
}

