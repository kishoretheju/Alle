//
//  GalleryViewController.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 29/09/23.
//

import UIKit
import PhotosUI
import Combine

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
  @IBOutlet weak var collectionViewTop: NSLayoutConstraint!
  @IBOutlet weak var pendingLabel: UILabel!
  @IBOutlet weak var uploadingLabel: UILabel!
  @IBOutlet weak var autoSyncView: UIView!
  
  let cellIdentifier = "cellIdentifier"
  
  let imagesRepo: ImagesRepository
  let databaseRepo: DatabaseRepository
  
  var gallery: Gallery? = nil
  
  var isUploading = false
  let syncManager: SyncManager
  var subscription: AnyCancellable? = nil
  var currentSyncStatus: SyncStatus? = nil
  
  init(_ imagesRepo: ImagesRepository,
       _ databaseRepo: DatabaseRepository,
       _ syncManager: SyncManager
  ) {
    self.imagesRepo = imagesRepo
    self.databaseRepo = databaseRepo
    self.syncManager = syncManager
    super.init(nibName: "GalleryViewController", bundle: nil)
    
    self.title = "Alle"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    subscription?.cancel()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    gallery = databaseRepo.getGalleries()[0]
    initializeCollectionView()
    
    autoSyncImages()
  }
  
  func autoSyncImages() {
    if let unwrappedGallery = gallery {
      let pendingImages = databaseRepo.getAllPendingImageRecords(inGallery: unwrappedGallery)
      if pendingImages.count > 0 {
        subscription = syncManager
          .$status
          .sink(receiveValue: { value in
            self.currentSyncStatus = value
            self.refreshView()
            print("This is called \(value)")
          })
        
        syncManager.uploadImages(pendingImages)
      }
      else {
        hideSyncProgressView()
      }
    }
  }
  
  func refreshView() {
    if self.currentSyncStatus!.isUploading {
      showSyncProgressView()
    }
    else {
      hideSyncProgressView()
    }
  }
  
  func showSyncProgressView() {
    collectionViewTop.constant = 60
    autoSyncView.isHidden = false
    
    pendingLabel.text = "Pending: \(self.currentSyncStatus?.pendingCount ?? 0)"
    uploadingLabel.text = "Uploading: \(self.currentSyncStatus?.consideredCount ?? 0)"
  }
  
  func hideSyncProgressView() {
    collectionViewTop.constant = 0
    autoSyncView.isHidden = true
  }
  
  func initializeCollectionView() {
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
