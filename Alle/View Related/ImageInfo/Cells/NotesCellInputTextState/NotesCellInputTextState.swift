//
//  NotestCellEditTextState.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 01/10/23.
//

import UIKit

protocol NotesCellInputTextStateDelegate: AnyObject {
  func didSelectDone(forCell cell: NotesCellInputTextState, andNote note: String?)
}

class NotesCellInputTextState: UITableViewCell, UITextFieldDelegate {
  
  @IBOutlet weak var textfield: UITextField!
  weak var delegate: NotesCellInputTextStateDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    textfield.delegate = self
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func didSelectDone(_ sender: Any) {
    delegate?.didSelectDone(forCell: self, andNote: self.textfield.text)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    delegate?.didSelectDone(forCell: self, andNote: self.textfield.text)
  }
}
