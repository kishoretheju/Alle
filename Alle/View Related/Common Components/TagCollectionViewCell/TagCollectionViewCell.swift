//
//  TagCollectionViewCell.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 01/10/23.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var containerView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    containerView.layer.cornerRadius = 4.0
    containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
    containerView.layer.shadowOpacity = 0.2
    containerView.layer.shadowColor = UIColor.black.cgColor
  }
}
