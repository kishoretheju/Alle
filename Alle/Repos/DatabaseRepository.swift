//
//  DatabaseRepository.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 02/10/23.
//

import Foundation
import RealmSwift

class DatabaseRepository {
  static let realm = try! Realm()
  typealias Completion = (_ success: Bool ,_ error: Error?) -> ()
  
  func realmInstance() -> Realm {
    let realm = try! Realm()
    return realm
  }
  
  func createGallery() -> Gallery {
    let gallery = Gallery()
    
    try! realmInstance().write {
      self.realmInstance().add(gallery)
    }
    
    return gallery
  }
  
  func createRecords(ofImages images: [String],
                     inGallery gallery: Gallery,
                     onCompletion: Completion? = nil) {
    try! realmInstance().write {
      for i in 0..<images.count {
        let image = ImageEntity(name: images[i])
        gallery.images.insert(image, at: i)
      }
    }
  }
  
  func getGalleries() -> [Gallery] {
    let realm = realmInstance()
    let galleries = realm.objects(Gallery.self)
    
    var array: [Gallery] = []
    for i in 0..<galleries.count {
      array.insert(galleries[i], at: i)
    }
    
    return array
  }
  
  func getAllImageRecords(inGallery gallery: Gallery) -> [ImageEntity] {
    return []
  }
  
  func getAllPendingImageRecords(inGallery gallery: Gallery) -> Results<ImageEntity> {
    let realm = realmInstance()
    
    let images = realm.objects(ImageEntity.self)
    let pendingImages = images.where { image in
      return image.isUploaded == false
    }
    
    return pendingImages
  }
  
  func updateUploadImageStatus(ofImage image: ImageEntity,
                               toStatus status: Bool) {
    let realm = realmInstance()
    
    try! realm.write {
      image.isUploaded = status
    }
  }
  
  func updateOcrTexts(ofImage image: ImageEntity,
                      toOcrTexts ocrTexts: [String]) {
    let realm = realmInstance()
    try! realm.write {
      for i in 0..<ocrTexts.count {
        image.ocrTexts.insert(ocrTexts[i], at: i)
      }
    }
  }
  
  func updateClassifications(ofImage image: ImageEntity,
                             toClassifications classifications: [Classification]) {
    let realm = realmInstance()
    try! realm.write {
      for i in 0..<classifications.count {
        image.classifications.insert(classifications[i], at: i)
      }
    }
  }
  
  func updateNotes(ofImage image: ImageEntity,
                   withNotes notes: String) {
    let realm = realmInstance()
    try! realm.write {
      image.notes = notes
    }
  }
}
