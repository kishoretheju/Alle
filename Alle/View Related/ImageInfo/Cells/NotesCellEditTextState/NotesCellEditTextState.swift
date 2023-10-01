//
//  NotesCellEditTextState.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 01/10/23.
//

import UIKit

//NotesCellEditTextState
protocol NotesCellEditTextStateDelegate: AnyObject {
  func didSelectEdit(forCell cell: NotesCellEditTextState)
}

class NotesCellEditTextState: UITableViewCell {
  
  @IBOutlet weak var notesLabel: UILabel!
  weak var delegate: NotesCellEditTextStateDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func didSelectEdit(_ sender: Any) {
    delegate?.didSelectEdit(forCell: self)
  }
}
