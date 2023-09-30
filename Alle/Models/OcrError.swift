//
//  OcrError.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 30/09/23.
//

import Foundation

enum OcrError: Error {
  case createImageFailed
  case cgImageConversionFailed
}

extension OcrError: CustomStringConvertible {
  public var description: String {
    switch self {
    case .createImageFailed:
      return "Could not create the image instance"
    case .cgImageConversionFailed:
      return "Could not converte UIImage to CGImage"
    }
  }
}

extension OcrError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .createImageFailed:
      return "Could not create the image instance"
    case .cgImageConversionFailed:
      return "Could not converte UIImage to CGImage"
    }
  }
}
