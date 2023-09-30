//
//  GalleryViewController.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 29/09/23.
//

import UIKit
import PhotosUI

fileprivate struct CollectionViewLayoutConstants {
  static let sectionInsets = UIEdgeInsets(
    top: 50.0,
    left: 20.0,
    bottom: 50.0,
    right: 20.0)
  static let itemsPerRow = 3
}

class GalleryViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  let cellIdentifier = "cellIdentifier"
  
  let imagesRepo: ImagesRepository
  var gallery: Gallery? = nil
  
  init(imagesRepo repo: ImagesRepository) {
    self.imagesRepo = repo
    super.init(nibName: "GalleryViewController", bundle: nil)
    
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
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let diContainer = AppScopeDependancyContainer.shared
    let imageVC = diContainer.makeImageViewController(gallery!, selectedIndex: indexPath.row)
    navigationController?.pushViewController(imageVC, animated: true)
  }
}

extension GalleryViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageCollectionViewCell
    if let image = gallery?.images[indexPath.row] {
      cell.imageView.image = UIImage(named: image.name)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return gallery?.images.count ?? 0
  }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let sectionInsets = CollectionViewLayoutConstants.sectionInsets
    let itemsPerRow = CollectionViewLayoutConstants.itemsPerRow
    
    let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / CGFloat(itemsPerRow)
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return CollectionViewLayoutConstants.sectionInsets
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return CollectionViewLayoutConstants.sectionInsets.left
  }
}
