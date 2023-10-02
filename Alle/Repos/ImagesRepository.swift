//
//  ImagesRepository.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 29/09/23.
//

import Foundation

class ImagesRepository {  
  func getImageNames() -> [String] {
    let range = 1...29
    return range.map { "screen\($0)" }
  }
}
