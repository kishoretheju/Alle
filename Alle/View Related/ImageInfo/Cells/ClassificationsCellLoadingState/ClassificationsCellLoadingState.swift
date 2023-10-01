//
//  ClassificationsCellLoadingState.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 01/10/23.
//

import UIKit

class ClassificationsCellLoadingState: UITableViewCell {
  
  @IBOutlet weak var loadingView: UIActivityIndicatorView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    loadingView.startAnimating()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
