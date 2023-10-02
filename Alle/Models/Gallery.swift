//
//  Gallery.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 29/09/23.
//

import Foundation
import RealmSwift

class Gallery: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var images = List<ImageEntity>()
}
