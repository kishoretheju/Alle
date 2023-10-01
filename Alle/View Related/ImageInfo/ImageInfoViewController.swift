//
//  ImageInfoViewController.swift
//  Alle
//
//  Created by Kishore Thejasvi M on 01/10/23.
//

import UIKit

fileprivate struct TableViewConstants {
  enum NotesCellIdentifiers: String, CaseIterable {
    typealias RawValue = String
    
    case addTextState = "NotesCellAddTextState"
    case inputTextState = "NotesCellInputTextState"
    case editTextState = "NotesCellEditTextState"
  }
  
  enum ClassificationsCellIdentifiers: String, CaseIterable {
    typealias RawValue = String
    
    case normal = "ClassificationsCell"
    case loading = "ClassificationsCellLoadingState"
  }
  
  enum DescriptionCellIdentifiers: String, CaseIterable {
    typealias RawValue = String
    
    case normal = "DescriptionCell"
    case loading = "DescriptionCellLoadingState"
  }
}

enum NotesCellUIState: Int {
  case add, input, edit
}

enum OtherCellUIState: Int {
  case normal, loading
}

class ImageInfoViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  let image: ImageEntity
  
  var notesCellState = NotesCellUIState.add
  var classificationsCellState = OtherCellUIState.loading
  var descriptionCellState = OtherCellUIState.loading
  
  init(_ image: ImageEntity) {
    self.image = image
    super.init(nibName: "ImageInfoViewController", bundle: nil)
    
    self.title = "Info"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    navigationItem.leftBarButtonItem = ComponentsFactory.cancelNavigationButton(forTarget: self,
                                                                                andAction: #selector(didSelectCancelButton))
    
    initializeTableView()
  }
  
  @objc
  func didSelectCancelButton() {
    dismiss(animated: true)
  }
  
  func initializeTableView() {
    registerCells()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func registerCells() {
    let cellNames = TableViewConstants.NotesCellIdentifiers.allCases.map{$0.rawValue}
    +
    TableViewConstants.NotesCellIdentifiers.allCases.map{$0.rawValue}
    +
    TableViewConstants.ClassificationsCellIdentifiers.allCases.map{$0.rawValue}
    
    TableViewConstants.DescriptionCellIdentifiers.allCases.forEach { eachCase in
      tableView.register(nib(forName: eachCase.rawValue),
                         forCellReuseIdentifier: eachCase.rawValue)
    }
    
    cellNames.forEach { eachName in
      tableView.register(nib(forName: eachName),
                         forCellReuseIdentifier: eachName)
    }
  }
  
  func nib(forName name: String) -> UINib {
    return UINib(nibName: name, bundle: nil)
  }
}

extension ImageInfoViewController: UITableViewDelegate {
  
}

extension ImageInfoViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    
    switch indexPath.row {
    case 0:
      cell = notesCell(forTableView: tableView)
    case 1:
      cell = classificationsCell(forTableView: tableView)
    default :
      cell = descriptionCell(forTableView: tableView)
    }
    
    return cell
  }
  
  func notesCell(forTableView tableView: UITableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableViewConstants.NotesCellIdentifiers.allCases[notesCellState.rawValue].rawValue)!
    return cell
  }
  
  func classificationsCell(forTableView tableView: UITableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableViewConstants.ClassificationsCellIdentifiers.allCases[classificationsCellState.rawValue].rawValue)!
    return cell
  }
  
  func descriptionCell(forTableView tableView: UITableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableViewConstants.DescriptionCellIdentifiers.allCases[descriptionCellState.rawValue].rawValue)!
    return cell
  }
}
