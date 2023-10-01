//
//  ImagesRepository.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 29/09/23.
//

import Foundation
import UIKit

class ImagesRepository {
  func getImages() -> Gallery {
    let range = 1...29
    let imageNames = range.map { "screenShot\($0)" }
    let images = imageNames.map { ImageEntity(name: $0) }
    return Gallery(images: images)
  }
}
