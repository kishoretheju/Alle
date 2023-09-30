//
//  ClassificationError.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 30/09/23.
//

import Foundation

enum ClassificationError: Error {
  case createImageFailed
  case ciImageConversionFailed
}

extension ClassificationError: CustomStringConvertible {
  public var description: String {
    switch self {
    case .createImageFailed:
      return "Could not create the image instance"
    case .ciImageConversionFailed:
      return "Could not converte UIImage to CGImage"
    }
  }
}

extension ClassificationError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .createImageFailed:
      return "Could not create the image instance"
    case .ciImageConversionFailed:
      return "Could not converte UIImage to CIImage"
    }
  }
}
