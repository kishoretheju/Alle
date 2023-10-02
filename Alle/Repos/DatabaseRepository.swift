//
//  DatabaseRepository.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 02/10/23.
//

import Foundation
import RealmSwift

class DatabaseRepository {
  typealias Completion = (_ success: Bool ,_ error: Error?) -> ()
  
  func createRecords(ofImages images: [String],
                     inGallery gallery: Gallery,
                     onCompletion: Completion?) {
    
  }
  
  func createRecords(ofClassifications classifications: [String],
                     inGallery gallery: Gallery,
                     onCompletion: Completion?) {
    
  }
  
  func getAllImageRecords(inGallery gallery: Gallery) -> [ImageEntity] {
    return []
  }
  
  func getAllPendingImageRecords(inGallery gallery: Gallery) -> [ImageEntity] {
    return []
  }
  
  func updateUploadImageStatus(ofImage: ImageEntity,
                               inGallery gallery: Gallery,
                               toStatus status: Bool, onCompletion: Completion?) {
    
  }
  
  func updateOcrTexts(ofImage: ImageEntity,
                      inGallery gallery: Gallery,
                      toOcrTexts ocrTexts: [String]?,
                      onCompletion: Completion?) {
    
  }
  
  func updateClassifications(ofImage: ImageEntity,
                             inGallery gallery: Gallery,
                             toClassifications classifications: [Classification]?,
                             onCompletion: Completion?) {
    
  }
}
