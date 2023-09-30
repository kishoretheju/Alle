//
//  Image.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 29/09/23.
//

import Foundation
import UIKit
import VisionKit
import Vision

class Image {
  let name: String
  let creationDate: Date = Date()
  var ocrTexts: [String]? = nil
  
  typealias CompletionBlock = (_ ocrTexts: [String]? ,_ error: Error?) -> ()
  
  init(name: String) {
    self.name = name
  }
  
  func getOcrDescription(withCompletion completion: @escaping CompletionBlock) {
    if let unwrappedOcrTexts = ocrTexts {
      return completion(ocrTexts, nil)
    }
    
    guard let cgImage = UIImage(named: name)?.cgImage
    else { return }
    
    let requestHandler = VNImageRequestHandler(cgImage: cgImage)
    let request = VNRecognizeTextRequest{ [weak self] request, error in
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
}

