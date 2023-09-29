//
//  GalleryViewController.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 29/09/23.
//

import UIKit
import PhotosUI

class GalleryViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  let cellIdentifier = "cellIdentifier"
  
  let imagesRepo: ImagesRepository
  var gallery: Gallery? = nil
  
  init(nibName nibNameOrNil: String?,
       bundle nibBundleOrNil: Bundle?,
       imagesRepo: ImagesRepository
  ) {
    self.imagesRepo = imagesRepo
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    self.title = "Alle"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    gallery = imagesRepo.getImages()
    initialiseCollectionView()
  }
  
  func initialiseCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    
    let customCellNib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
    collectionView.register(customCellNib, forCellWithReuseIdentifier: cellIdentifier)
  }
  
  func reloadCollectionView() {
    collectionView.reloadData()
  }
}

extension GalleryViewController: UICollectionViewDelegate {
  
}

extension GalleryViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageCollectionViewCell
    if let image = gallery?.images[indexPath.row] {
      cell.imageView.image = image
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return gallery?.images.count ?? 0
  }
}
