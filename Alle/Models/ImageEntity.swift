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

class ImageEntity {
  let name: String
  let creationDate: Date = Date()
  var ocrTexts: [String]? = nil
  var classifications: [Classification]? = nil
  
  typealias OcrCompletion = (_ ocrTexts: [String]? ,_ error: Error?) -> ()
  typealias ClassificationsCompletion = (_ collections: [Classification]? ,_ error: Error?) -> ()
  
  init(name: String) {
    self.name = name
  }
  
  func getOcrDescription(withCompletion completion: @escaping OcrCompletion) {
    if let _ = ocrTexts {
      return completion(ocrTexts, nil)
    }
    
    guard let imageInstance = UIImage(named: name)
    else {
      completion(nil, OcrError.createImageFailed)
      return
    }
    
    guard let cgImage = imageInstance.cgImage
    else {
      completion(nil, OcrError.cgImageConversionFailed)
      return
    }
    
    let requestHandler = VNImageRequestHandler(cgImage: cgImage)
    let request = VNRecognizeTextRequest{ [weak self] request, error in
      if let _ = error {
        completion(nil, error)
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
      
      self?.ocrTexts = recognizedStrings
      completion(recognizedStrings, nil)
    }
    
    do {
      try requestHandler.perform([request])
    }
    catch {
      completion(nil, error)
    }
  }
  
  func getClassifications(withCompletion completion: @escaping ClassificationsCompletion) {
    if let _ = classifications {
      return completion(classifications, nil)
    }
    
    guard let imageInstance = UIImage(named: name)
    else {
      completion(nil, ClassificationError.createImageFailed)
      return
    }
    
    guard let ciImage = CIImage(image:imageInstance)
    else {
      completion(nil, ClassificationError.ciImageConversionFailed)
      return
    }
    
    let handler = VNImageRequestHandler(ciImage: ciImage)
    
    let request = VNClassifyImageRequest { [weak self] classifyRequest, error in
      if let _ = error {
        completion(nil, error)
        return
      }
      
      guard let _ = classifyRequest.results
      else {
        completion([], nil)
        return
      }
      
      if let results = classifyRequest.results as? [VNClassificationObservation] {
        let classifications = results.map { Classification(name: $0.identifier, confidence: $0.confidence) }

        self?.classifications = classifications
        completion(classifications, nil)
      }
      else {
        completion([], nil)
      }
    }
    
#if targetEnvironment(simulator)
    request.usesCPUOnly = true
#endif
    
    do {
      try handler.perform([request])
    } catch let error {
      completion(nil, error)
    }
  }
}

