//
//  NotesCellEditTextState.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 01/10/23.
//

import UIKit

class NotesCellEditTextState: UITableViewCell {
  
  @IBOutlet weak var notesLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func didSelectEdit(_ sender: Any) {
    
  }
}
