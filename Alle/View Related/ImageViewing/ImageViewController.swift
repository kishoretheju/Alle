//
//  ImageViewController.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 29/09/23.
//

import UIKit

fileprivate struct CollectionViewConstants {
  static let sectionInsets = UIEdgeInsets(
    top: 5.0,
    left: 5.0,
    bottom: 5.0,
    right: 5.0)
  static let itemsPerRow = 3
  static let cellIdentifier = "cellIdentifier"
  static let cellNibName = "ThumnailCollectionViewCell"
  static let cellHeight = 48
  static let cellHeightSelected = 64
  static let cellWidth = 48
  static let cellWidthSelected = 64
}

class ImageViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  let gallery: Gallery
  var selectedIndex: Int
  
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
    
    setDetailImage()
    initialiseCollectionView()
    scroll(toIndex: selectedIndex)
  }
  
  func setDetailImage() {
    imageView.image = UIImage(named: selectedImage.name)
  }
  
  func initialiseCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    
    let customCellNib = UINib(nibName: CollectionViewConstants.cellNibName, bundle: nil)
    collectionView.register(customCellNib, forCellWithReuseIdentifier: CollectionViewConstants.cellIdentifier)
  }
  
  func reloadCollectionView() {
    collectionView.reloadData()
  }
  
  func didSelect(_ index: Int) {
    selectedIndex = index
  }
  
  func scroll(toIndex index: Int) {
    collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
  }
}

extension ImageViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    didSelect(indexPath.row)
    reloadCollectionView()
    
    scroll(toIndex: indexPath.row)
    
    setDetailImage()
  }
}

extension ImageViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewConstants.cellIdentifier,
                                                  for: indexPath) as! ThumnailCollectionViewCell
    let imageData = gallery.images[indexPath.row]
    cell.imageView.image = UIImage(named: imageData.name)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return gallery.images.count
  }
}

extension ImageViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let sectionInsets = CollectionViewConstants.sectionInsets
    
    let isSelectedIndex = indexPath.row == selectedIndex
    
    let cellWidth = isSelectedIndex ? CollectionViewConstants.cellWidthSelected : CollectionViewConstants.cellWidth
    let cellHeight = isSelectedIndex ? CollectionViewConstants.cellHeightSelected : CollectionViewConstants.cellHeight
  
    return CGSize(width: cellWidth, height: cellHeight)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return CollectionViewConstants.sectionInsets
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return CollectionViewConstants.sectionInsets.left
  }
}
