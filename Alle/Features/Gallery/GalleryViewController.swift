//
//  GalleryViewController.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 29/09/23.
//

import UIKit
import PhotosUI

class GalleryViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  
  let pickerVC: PHPickerViewController
  let imagesRepo: ImagesRepository
  
  init(nibName nibNameOrNil: String?,
       bundle nibBundleOrNil: Bundle?,
       pickerVC: PHPickerViewController,
       imagesRepo: ImagesRepository
  ) {
    self.pickerVC = pickerVC
    self.imagesRepo = imagesRepo
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    self.pickerVC.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    //    addPickerViewControllerAsChild()
    loadImages()
  }
  
  func addPickerViewControllerAsChild() {
    addChild(pickerVC)
    view.addSubview(pickerVC.view)
    pickerVC.didMove(toParent: self)
  }
  
  func loadImages() {
    let images = imagesRepo.getImages()
    imageView.image = images[0]
  }
}

extension GalleryViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    
  }
}
