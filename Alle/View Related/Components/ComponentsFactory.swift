//
//  ComponentsFactory.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 01/10/23.
//

import Foundation
import UIKit

class ComponentsFactory {
  class func infoNavigationButton(forTarget target: Any,
                                  andAction action: Selector) -> UIBarButtonItem {
    let buttonImage = UIImage(systemName: "info.circle")
    return UIBarButtonItem(image: buttonImage,
                    landscapeImagePhone: buttonImage,
                    style: .plain,
                    target: target,
                    action: action)
  }
}
