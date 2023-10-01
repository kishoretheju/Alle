//
//  NotesCellAddTextState.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 01/10/23.
//

import UIKit

protocol NotesCellAddTextStateDelegate: AnyObject {
  func didSelectAdd()
}

class NotesCellAddTextState: UITableViewCell {
  weak var delegate: NotesCellAddTextStateDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func didSelectAdd(_ sender: Any) {
    delegate?.didSelectAdd()
  }
}
