//
//  DescriptionCell.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 01/10/23.
//

import UIKit

protocol DescriptionCellDataSource: AnyObject {
  func descriptionText() -> String
}

class DescriptionCell: UITableViewCell {
  
  @IBOutlet weak var descriptionLabel: UILabel!
  weak var dataSource: DescriptionCellDataSource?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    setDescription()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setDescription() {
    descriptionLabel.text = dataSource?.descriptionText()
  }
}
