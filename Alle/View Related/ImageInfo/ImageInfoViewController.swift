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
  let visionRepo: VisionRepository
  let databaseRepo: DatabaseRepository
  
  var notesCellState: NotesCellUIState = .add
  
  var classificationsCellState = OtherCellUIState.loading
  var descriptionCellState = OtherCellUIState.loading
  
  init(_ image: ImageEntity, _ visionRepo: VisionRepository,_ databaseRepo: DatabaseRepository) {
    self.image = image
    self.visionRepo = visionRepo
    self.databaseRepo = databaseRepo
    
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
    
    initializeNotesCellState()
    initializeTableView()
    
    if modelHasClassifications() {
      classificationsCellState = .normal
    }
    else {
      classificationsCellState = .loading
      getClassificationsDataAndRefreshView()
    }
    
    if modelHasDescription() {
      descriptionCellState = .normal
    }
    else {
      descriptionCellState = .loading
      getDescriptionDataAndRefreshView()
    }
  }
  
  func initializeNotesCellState() {
    if let unwrappedNotes = image.notes, unwrappedNotes != "" {
      if unwrappedNotes == "" {
        notesCellState = .add
      }
      else {
        notesCellState = .edit
      }
    } else {
      notesCellState = .add
    }
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
  
  func modelHasClassifications() -> Bool {
    return image.classifications.count > 0
  }
  
  func getClassificationsDataAndRefreshView() {
    visionRepo.getClassifications(forImage: image) { classifications, error in
      guard let _ = classifications else {
        return
      }

      self.classificationsCellState = OtherCellUIState.normal
      self.tableView.reloadData()
    }
  }
  
  func modelHasDescription() -> Bool {
    return image.ocrTexts.count > 0
  }
  
  func getDescriptionDataAndRefreshView() {
    visionRepo.getOcrDescription(forImage: image) { ocrTexts, error in
      guard let _ = ocrTexts else {
        return
      }
      
      self.descriptionCellState = OtherCellUIState.normal
      self.tableView.reloadData()
    }
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
    
    if let convertedCell = cell as? NotesCellAddTextState {
      convertedCell.delegate = self
    }
    else if let convertedCell = cell as? NotesCellInputTextState {
      convertedCell.delegate = self
      convertedCell.textfield.text = image.notes
    }
    else if let convertedCell = cell as? NotesCellEditTextState {
      convertedCell.notesLabel.text = image.notes
      convertedCell.delegate = self
    }
    
    return cell
  }
  
  func classificationsCell(forTableView tableView: UITableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableViewConstants.ClassificationsCellIdentifiers.allCases[classificationsCellState.rawValue].rawValue)!
    
    if let convertedCell = cell as? ClassificationsCell {
      convertedCell.dataSource = self
      convertedCell.showClassifications()
    }
    
    return cell
  }
  
  func descriptionCell(forTableView tableView: UITableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableViewConstants.DescriptionCellIdentifiers.allCases[descriptionCellState.rawValue].rawValue)!
    if let convertedCell = cell as? DescriptionCell {
      convertedCell.dataSource = self
      convertedCell.setDescription()
    }
    return cell
  }
}

extension ImageInfoViewController: ClassificationsCellDataSource {
  func classificationsTexts() -> [String] {
    //    if let classifications = image.classifications {
    //      let lastIndex = (classifications.count >= 5) ? 4 : (classifications.count - 1)
    //      let filtered = classifications[0...lastIndex]
    //
    //      return filtered.map { $0.name }
    //    }
    
    let classifications = image.classifications
    let lastIndex = (classifications.count >= 5) ? 4 : (classifications.count - 1)
    let filtered = classifications[0...lastIndex]
    
    return filtered.map { $0.name }
  }
}

extension ImageInfoViewController: DescriptionCellDataSource {
  func descriptionText() -> String {
    let descriptionTexts = image.ocrTexts
    return descriptionTexts.reduce("", { partialResult, value in
      return partialResult + " " + value
    })
  }
}

extension ImageInfoViewController: NotesCellAddTextStateDelegate {
  func didSelectAdd() {
    notesCellState = .input
    
    self.tableView.reloadData()
  }
}

extension ImageInfoViewController: NotesCellInputTextStateDelegate {
  func didSelectDone(forCell cell: NotesCellInputTextState, andNote note: String?) {
    let text = cell.textfield.text
    
    if let unwrappedText = text, unwrappedText != "" {
      notesCellState = .edit
      
      databaseRepo.updateNotes(ofImage: image, withNotes: unwrappedText)
    }
    else {
      notesCellState = .add
    }
    
    self.tableView.reloadData()
  }
}

extension ImageInfoViewController: NotesCellEditTextStateDelegate {
  func didSelectEdit(forCell cell: NotesCellEditTextState) {
    notesCellState = .input
    
    self.tableView.reloadData()
  }
}
