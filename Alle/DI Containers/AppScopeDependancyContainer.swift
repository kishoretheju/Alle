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
  let databaseRepo = DatabaseRepository()
  
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
    return GalleryViewController(imagesRepo, databaseRepo, makeSyncManager())
  }
  
  func makeImageViewController(_ gallery: Gallery, selectedIndex index: Int) -> ImageViewController {
    return ImageViewController(gallery, selectedIndex: index)
  }
  
  func imageInfoNavigationController(_ image: ImageEntity) -> UINavigationController {
    let imageInfoVC = makeImageInfoViewController(image)
    let nc = UINavigationController(rootViewController: imageInfoVC)
    nc.navigationBar.barTintColor = UIColor.green
    return nc
  }
  
  func makeImageInfoViewController(_ image: ImageEntity) -> ImageInfoViewController {
    let visionRepo = VisionRepository(databaseRepo)
    return ImageInfoViewController(image, visionRepo, databaseRepo)
  }
  
  func makeSyncManager() -> SyncManager {
    return SyncManager(databaseRepo: databaseRepo)
  }
}
