//
//  ImageViewController.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 29/09/23.
//

import UIKit

class ImageViewController: UIViewController {
  let gallery: Gallery
  let selectedIndex: Int
  
  var selectedImage: Image {
    get {
      return gallery.images[selectedIndex]
    }
  }
  
  init(_ gallery: Gallery, selectedIndex index: Int) {
    self.gallery = gallery
    self.selectedIndex = index
    super.init(nibName: "ImageViewController", bundle: nil)
    
    self.title = selectedImage.creationDate.formatted()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
