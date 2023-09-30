//
//  AlleAppScopeContainer.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 29/09/23.
//

import Foundation
import UIKit
import PhotosUI

class AppScopeDependancyContainer: NSObject {
  
  static let shared = AppScopeDependancyContainer()
  let imagesRepo = ImagesRepository()
  
  private override init() {
    
  }
  
  func mainNavigationController() -> UINavigationController {
    let mainViewController = makeGalleryViewController()
    let navigationController = UINavigationController(rootViewController: mainViewController)
    return navigationController
  }
  
  func pickerViewController() -> PHPickerViewController {
    var config = PHPickerConfiguration()
    config.selectionLimit = 3
    config.filter = PHPickerFilter.images
    
    let pickerVC = PHPickerViewController(configuration: config)
    return pickerVC
  }
  
  func makeGalleryViewController() -> GalleryViewController {
    return GalleryViewController(imagesRepo: imagesRepo)
  }
  
  func makeImageViewController(_ gallery: Gallery, selectedIndex index: Int) -> ImageViewController {
    return ImageViewController(gallery, selectedIndex: index)
  }
}
