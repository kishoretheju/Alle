//
//  VisionRepository.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 02/10/23.
//

import Foundation
import UIKit
import VisionKit
import Vision
import RealmSwift

class VisionRepository {
  typealias OcrCompletion = (_ ocrTexts: [String]? ,_ error: Error?) -> ()
  typealias ClassificationsCompletion = (_ classifications: [Classification]?,_ error: Error?) -> ()
  
  let databaseRepo: DatabaseRepository
  
  init(_ databaseRepo: DatabaseRepository) {
    self.databaseRepo = databaseRepo
  }
  
  func callOnMain(_ action: @escaping () -> ()) {
    DispatchQueue.main.async {
      action()
    }
  }
  
  func callOnAsyncThread(_ action: @escaping () -> ()) {
    DispatchQueue.global(qos: .userInteractive).async {
      action()
    }
  }
  
  func getOcrDescription(forImage image:ImageEntity, withCompletion completion: @escaping OcrCompletion) {
    if image.ocrTexts.count > 0  {
      var convertedStrings: [String] = []
      image.ocrTexts.forEach { value in
        convertedStrings.append(value)
      }
      
      return completion(convertedStrings, nil)
    }
    
    let imageName = image.name
    
    self.callOnAsyncThread {
      guard let imageInstance = UIImage(named: imageName)
      else {
        self.callOnMain {
          completion(nil, OcrError.createImageFailed)
        }
        
        return
      }
      
      guard let cgImage = imageInstance.cgImage
      else {
        self.callOnMain {
          completion(nil, OcrError.cgImageConversionFailed)
        }
        
        return
      }
      
      let requestHandler = VNImageRequestHandler(cgImage: cgImage)
      let request = VNRecognizeTextRequest{ [weak self] request, error in
        if let _ = error {
          self?.callOnMain {
            completion(nil, error)
          }
          
          return
        }
        
        guard let observations = request.results
        else {
          return
        }
        
        let recognizedStrings: [String] = observations.compactMap { observation in
          guard let textObservation = observation as? VNRecognizedTextObservation
          else
          { return nil }
          
          return textObservation.topCandidates(1).first?.string
        }
        
        self?.callOnMain {
          self?.databaseRepo.updateOcrTexts(ofImage: image, toOcrTexts: recognizedStrings)
          completion(recognizedStrings, nil)
        }
      }
      
      do {
        try requestHandler.perform([request])
      }
      catch {
        self.callOnMain {
          completion(nil, error)
        }
      }
    }
  }
  
  func getClassifications(forImage image:ImageEntity, withCompletion completion: @escaping ClassificationsCompletion) {
    if image.classifications.count > 0  {
      var array: [Classification] = []
      image.classifications.forEach { classification in
        array.append(classification)
      }
      return completion(array, nil)
    }
    
    let imageName = image.name
    
    self.callOnAsyncThread {
      guard let imageInstance = UIImage(named: imageName)
      else {
        self.callOnMain {
          completion(nil, ClassificationError.createImageFailed)
        }
        
        return
      }
      
      guard let ciImage = CIImage(image:imageInstance)
      else {
        self.callOnMain {
          completion(nil, ClassificationError.ciImageConversionFailed)
        }
        
        return
      }
      
      let handler = VNImageRequestHandler(ciImage: ciImage)
      
      let request = VNClassifyImageRequest { [weak self] classifyRequest, error in
        if let _ = error {
          self?.callOnMain {
            completion(nil, error)
          }
          
          return
        }
        
        guard let _ = classifyRequest.results
        else {
          self?.callOnMain {
            completion([], nil)
          }
          
          return
        }
        
        if let results = classifyRequest.results as? [VNClassificationObservation] {
          let result = results.map { Classification(name: $0.identifier, confidence: $0.confidence) }
          
          self?.callOnMain {
            self?.databaseRepo.updateClassifications(ofImage: image, toClassifications: result)
            completion(result, nil)
          }
        }
        else {
          self?.callOnMain {
            completion([], nil)
          }
        }
      }
      
#if targetEnvironment(simulator)
      request.usesCPUOnly = true
#endif
      
      do {
        try handler.perform([request])
      } catch let error {
        self.callOnMain {
          completion(nil, error)
        }
      }
    }
  }
}
