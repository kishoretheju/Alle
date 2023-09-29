//
//  ImagesRepository.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 29/09/23.
//

import Foundation
import UIKit

class ImagesRepository {
  func getImages() -> [UIImage] {
    let imageNames = ["screenShot1",
                      "screenShot2",
                      "screenShot3",
                      "screenShot4",
                      "screenShot5",
                      "screenShot6",
                      "screenShot7",
                      "screenShot8",
                      "screenShot9",
                      "screenShot10",
                      "screenShot11",
                      "screenShot12",
                      "screenShot13",
                      "screenShot14"]
    let images = imageNames.map { UIImage(named: $0) }.compactMap { $0 }
    return images
  }
}
