//
//  ThumnailCollectionViewCell.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 30/09/23.
//

import UIKit

class ThumnailCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var containerView: UIView!
  
  let highlightColor = ColorConstants.secondaryColor.cgColor
  let normalColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
  
  var shouldHighlight: Bool = false {
    didSet {
      self.updateBorderColor()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    containerView.layer.borderWidth = 1.0
    containerView.layer.cornerRadius = 2.0
    containerView.layer.masksToBounds = true
    containerView.clipsToBounds = true
  }
  
  func updateBorderColor() {
    containerView.layer.borderColor = shouldHighlight ? highlightColor : normalColor
  }
}
