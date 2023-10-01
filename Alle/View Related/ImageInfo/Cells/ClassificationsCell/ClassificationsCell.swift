//
//  ClassificationsCell.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 01/10/23.
//

import UIKit

protocol ClassificationsCellDataSource: AnyObject {
  func classificationsTexts() -> [String]
}

class ClassificationsCell: UITableViewCell {
  
  @IBOutlet weak var collectionView: UICollectionView!
  weak var dataSource: ClassificationsCellDataSource? = nil
  var texts: [String]? = nil
  
  let cellIdentifier = "TagCollectionViewCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    initializeCollectionView()
    showClassifications()
  }
  
  func showClassifications() {
    guard let unwrappedDatasource = dataSource else {
      return
    }
    
    texts = unwrappedDatasource.classificationsTexts()
    collectionView.reloadData()
  }
  
  func initializeCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    
    let customCellNib = UINib(nibName: cellIdentifier, bundle: nil)
    collectionView.register(customCellNib, forCellWithReuseIdentifier: cellIdentifier)
  }
  
  func nib(forName name: String) -> UINib {
    return UINib(nibName: name, bundle: nil)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}

extension ClassificationsCell: UICollectionViewDelegate {
  
}

extension ClassificationsCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return texts?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TagCollectionViewCell
    cell.label.text = (texts?[indexPath.row] ?? "")
    return cell
  }
}

extension ClassificationsCell: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: 100, height: 30)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }
}


