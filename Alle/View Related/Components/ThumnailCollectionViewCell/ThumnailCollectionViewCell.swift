//
//  ThumnailCollectionViewCell.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 30/09/23.
//

import UIKit

class ThumnailCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    imageView.layer.cornerRadius = 5.0
  }
  
}
