//
//  UpdateTagViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/15/24.
//

import UIKit
import KazUtility
import SnapKit
import RealmSwift

final class UpdateTagViewController: BaseViewController {
  
  enum UpdateTagError: KazUtility.AppError {
    case aledyTagging(tag: String)
    
    var logDescription: String {
      return ""
    }
    
    var alertDescription: String {
      switch self {
        case .aledyTagging(let tag):
          return "#\(tag)는 이미 태그하고있어요!"
      }
    }
  }
  
  // MARK: - UI
  private lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionLayout()).configured {
    $0.delegate = self
    $0.dataSource = self
    $0.showsHorizontalScrollIndicator = false
    $0.keyboardDismissMode = .onDrag
    $0.register(
      TodoTagCollectionViewCell.self,
      forCellWithReuseIdentifier: TodoTagCollectionViewCell.identifier
    )
  }
  
  private lazy var tagInputField = UITextField().configured {
    $0.placeholder = "태그를 입력해주세요"
    $0.borderStyle = .roundedRect
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
    $0.delegate = self
    $0.becomeFirstResponder()
    $0.addTarget(self, action: #selector(tagInputChanged), for: .editingChanged)
  }
  
  private let tagTitleLengthInfoLabel = UILabel().configured {
    $0.textColor = .gray
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.textAlignment = .right
  }
  
  private lazy var addTagButton = UIButton().configured { button in
    button.configuration = .filled().configured {
      $0.buttonSize = .medium
      $0.cornerStyle = .medium
      $0.titleLineBreakMode = .byTruncatingMiddle
    }
    
    button.addTarget(self, action: #selector(addTagButtonTapped), for: .touchUpInside)
  }
  
  // MARK: - Property
  var delegate: any UpdateConfigDelegate
  weak var coordinator: AddTodoCoordinator?
  private let repository: TodoTagRepository
  private let tags: List<TodoTag>
  private let maxTagTitleLength: Int = 6
  
  private var tagTitle: String {
    return tagInputField.text ?? ""
  }
  
  private var tagTitleLength: Int {
    return tagTitle.count
  }
  
  // MARK: - Initializer
  init(repository: TodoTagRepository, tags: List<TodoTag>, delegate: any UpdateConfigDelegate) {
    self.repository = repository
    self.tags = tags
    self.delegate = delegate
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    delegate.tagsDidUpdate()
  }
  
  override func setHierarchy() {
    view.addSubviews(tagCollectionView, tagInputField, tagTitleLengthInfoLabel, addTagButton)
  }
  
  override func setAttribute() {
    updateTagTitleLengthInfo()
    updateAddTagButtonTitle(isEmpty: tagTitle.isEmpty)
    updateAddTagButtonEnabled(isEmpty: tagTitle.isEmpty)
  }
  
  override func setConstraint() {
    tagCollectionView.snp.makeConstraints { make in
      make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(60)
    }
    
    tagInputField.snp.makeConstraints { make in
      make.top.equalTo(tagCollectionView.snp.bottom).offset(8)
      make.horizontalEdges.equalTo(view).inset(16)
    }
    
    tagTitleLengthInfoLabel.snp.makeConstraints { make in
      make.top.equalTo(tagInputField.snp.bottom).offset(8)
      make.trailing.equalTo(view).inset(16)
    }
    
    addTagButton.snp.makeConstraints { make in
      make.top.equalTo(tagTitleLengthInfoLabel.snp.bottom).offset(8)
      make.horizontalEdges.equalTo(view).inset(16)
    }
  }
  
  // MARK: - Method
  private func updateTagTitleLengthInfo() {
    tagTitleLengthInfoLabel.text = "\(tagTitleLength) / \(maxTagTitleLength)"
  }
  
  private func updateAddTagButtonEnabled(isEmpty: Bool) {
    addTagButton.isEnabled = !isEmpty
  }
  
  private func updateAddTagButtonTitle(isEmpty: Bool) {
    addTagButton.configuration?.title = isEmpty ? "태그를 입력해주세요" : "추가하기"
  }
  
  private func clearInputField() {
    tagInputField.text = ""
  }
  
  private func addTag() {
    let newTag = TodoTag(name: tagTitle)
    let tagTitleList = repository.fetch().map { $0.name }
    
    guard !tagTitleList.contains(newTag.name) else {
      coordinator?.handle(error: UpdateTagError.aledyTagging(tag: tagTitle))
      return
    }
    
    do {
      try repository.create(with: newTag)
      tags.append(newTag)
      tagCollectionView.reloadData()
      scrollToLastItem()
    } catch {
      LogManager.shared.log(with: RealmError.addFailed(error: error), to: .local)
    }
  }
  
  private func scrollToLastItem() {
    let lastIndexPath = IndexPath(row: repository.fetch().count - 1, section: 0)
    tagCollectionView.scrollToItem(at: lastIndexPath, at: .right, animated: false)
  }
  
  // MARK: - Selector
  @objc private func tagInputChanged() {
    updateTagTitleLengthInfo()
    updateAddTagButtonEnabled(isEmpty: tagTitle.isEmpty)
    updateAddTagButtonTitle(isEmpty: tagTitle.isEmpty)
  }
  
  @objc private func addTagButtonTapped() {
    addTag()
    clearInputField()
    updateTagTitleLengthInfo()
    updateAddTagButtonEnabled(isEmpty: tagTitle.isEmpty)
    updateAddTagButtonTitle(isEmpty: tagTitle.isEmpty)
  }
}

extension UpdateTagViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return tagTitleLength < maxTagTitleLength
  }
}

extension UpdateTagViewController: CollectionControllable {
  
  private func makeCollectionLayout() -> UICollectionViewFlowLayout {
    return UICollectionViewFlowLayout().configured {
      $0.itemSize = CGSize(width: 80, height: 30)
      $0.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
      $0.minimumLineSpacing = 8
      $0.scrollDirection = .horizontal
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return repository.fetch().count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoTagCollectionViewCell.identifier, for: indexPath) as! TodoTagCollectionViewCell
    
    let tag = repository.fetch()[indexPath.row]
    cell.updateUI(with: tag.name, isTagging: tags.contains(tag), row: indexPath.row)
    
    cell.updateTagAction = { [weak self] in
      guard let self else { return }
      defer { collectionView.reloadData() }
      guard let index = tags.firstIndex(of: tag) else {
        tags.append(tag)
        return
      }
      
      tags.remove(at: index)
    }
    
    return cell
  }
}
