//
//  MakeTodoViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/15/24.
//

import UIKit
import KazUtility
import SnapKit

enum MakeTodoStyle {
  case add(box: TodoBox)
  case update(todo: TodoItem)
  
  var title: String {
    switch self {
      case .add:
        return "새로운 할 일"
      case .update:
        return "할 일 수정하기"
    }
  }
  
  var barTitle: String {
    switch self {
      case .add:
        return "추가"
      case .update:
        return "수정"
    }
  }
}


// FIXME: 업데이트를 모두 트랜잭션에서 하도록 수정하고, Realm에 올렸다가 취소하면 Delete 하는 로직으로 변경
/// 취소 시 업데이트 변경사항을 반영하지 않아야되는데, 예외처리 가능한지 확인
/// 뷰모델 들어올 때 id 포함해서 복사 한번하고, 덮어씌우는 방식으로 해야할 듯
final class MakeTodoViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private let cardView = CardView()
  
  private lazy var titleTextField = UITextField().configured {
    $0.placeholder = "제목"
    $0.tintColor = .accent
    $0.borderStyle = .none
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
    $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    $0.becomeFirstResponder()
  }
  
  private let divider = Divider()
  
  private let memoTextView = UITextView().configured {
    $0.font = .systemFont(ofSize: 15, weight: .regular)
    $0.showsVerticalScrollIndicator = false
    $0.backgroundColor = .clear
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
  }
  
  private lazy var updateBoxButton = UIButton().configured {
    $0.configuration = .tinted().configured {
      $0.buttonSize = .large
      $0.cornerStyle = .large
      $0.baseForegroundColor = .white
      $0.imagePadding = 12
      $0.imagePlacement = .leading
    }
    
    $0.addTarget(self, action: #selector(updateBoxButtonTapped), for: .touchUpInside)
  }
  
  private lazy var configTableView = UITableView().configured {
    $0.keyboardDismissMode = .onDrag
    $0.register(TodoConfigTableViewCell.self, forCellReuseIdentifier: TodoConfigTableViewCell.identifier)
    $0.delegate = self
    $0.dataSource = self
    $0.isScrollEnabled = false
  }
  
  private let photoImageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFit
  }
  
  // MARK: - Property
  let viewModel: MakeTodoViewModel
  
  private var titleText: String {
    return titleTextField.text ?? ""
  }
  
  private var memo: String {
    return memoTextView.text ?? ""
  }
  
  // MARK: - Initialzier
  init(viewModel: MakeTodoViewModel, makeTodoStyle: MakeTodoStyle) {
    self.viewModel = viewModel
    
    super.init()
    
    setBarItems(style: makeTodoStyle)
    updateUI()
    updateBoxUI(with: viewModel.currentBox)
    
    NotificationManager.shared.add(self, key: TodoNotification.NameKey.updateConfig) { [weak self] notification in
      guard let self else { return }
      
      if let flag = notification.userInfo?[TodoNotification.InfoKey.flag.name] as? Bool {
        viewModel.updateFlag(with: flag)
        reloadConfig(with: .flag)
      }
      
      if let priority = notification.userInfo?[TodoNotification.InfoKey.priority.name] as? Int {
        viewModel.updatePriority(with: priority)
        reloadConfig(with: .priority)
      }
      
      if let box = notification.userInfo?[TodoNotification.InfoKey.box.name] as? TodoBox {
        viewModel.updateBox(with: box)
        updateBoxUI(with: box)
      }
    }
  }
  
  deinit {
    NotificationManager.shared.remove(self)
  }
  
  // MARK: - Life Cycle
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
  }
  
  override func setHierarchy() {
    view.addSubviews(cardView, updateBoxButton, configTableView, photoImageView)
    cardView.addSubviews(titleTextField, divider, memoTextView)
  }
  
  override func setConstraint() {
    cardView.snp.makeConstraints { make in
      make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
    }
    
    titleTextField.snp.makeConstraints { make in
      make.top.horizontalEdges.equalTo(cardView).inset(16)
    }
    
    divider.snp.makeConstraints { make in
      make.top.equalTo(titleTextField.snp.bottom).offset(8)
      make.horizontalEdges.equalTo(cardView).inset(8)
    }
    
    memoTextView.snp.makeConstraints { make in
      make.top.equalTo(divider.snp.bottom).offset(8)
      make.bottom.horizontalEdges.equalTo(cardView).inset(12)
      make.height.equalTo(150)
    }
    
    updateBoxButton.snp.makeConstraints { make in
      make.top.equalTo(cardView.snp.bottom).offset(16)
      make.horizontalEdges.equalTo(view).inset(16)
    }
    
    configTableView.snp.makeConstraints { make in
      make.top.equalTo(updateBoxButton.snp.bottom).offset(8)
      make.horizontalEdges.equalTo(view).inset(16)
    }
    
    photoImageView.snp.makeConstraints { make in
      make.top.equalTo(configTableView.snp.bottom).offset(8)
      make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.size.equalTo(150)
    }
  }
  
  // MARK: - Method
  private func updateUI() {
    let todoItem = viewModel.object
    
    titleTextField.text = todoItem.title
    memoTextView.text = todoItem.memo
  }
  
  private func setBarItems(style: MakeTodoStyle) {
    let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelBarButtonTapped))
    let make = UIBarButtonItem(title: style.barTitle, style: .plain, target: self, action: #selector(addBarButtonTapped))
    
    navigationItem.leftBarButtonItem = cancel
    navigationItem.rightBarButtonItem = make
    
    updateAddButtonEnabled(isTitleEmpty: titleText.isEmpty)
  }
  
  private func updateAddButtonEnabled(isTitleEmpty: Bool) {
    navigationItem.rightBarButtonItem?.isEnabled = !isTitleEmpty
  }
  
  private func showUpdateConfigView(with config: TodoConfiguration) {
    switch config {
      case .dutDate:
        viewModel.showUpdateDueDateView(current: viewModel.object.dueDate, config: config) { [weak self] date in
          guard let self else { return }
          
          viewModel.updateDueDate(with: date)
          reloadConfig(with: config)
        }
        
      case .flag:
        viewModel.showUpdateFlagView(current: viewModel.object.isFlag, config: config)
      
      case .tag:
        viewModel.showUpdateTagView(config: config, tags: viewModel.object.tags, delegate: self)
        
      case .priority:
        viewModel.showUpdatePriorityView(current: viewModel.object.priority, config: config)
        
      case .addImage:
        showPhotoSelectionActionSheet()
    }
  }
  
  private func reloadConfig(with config: TodoConfiguration) {
    configTableView.reloadRow(row: config.row)
  }
  
  private func updateBoxUI(with box: TodoBox) {
    guard let icon = box.icon else { return }
    
    updateBoxButton.configuration?.configure {
      $0.title = box.name
      $0.image = UIImage(systemName: icon.symbol)
      $0.baseBackgroundColor = UIColor(hex: icon.color)
    }
  }
  
  private func showPhotoSelectionActionSheet() {
    let alert = UIAlertController(title: "사진을 어떻게 가져올까요?", message: nil, preferredStyle: .actionSheet)
      .setAction(title: GetPhotoSelection.camera.title, style: .default) { self.showGetPhotoView(selection: .camera) }
      .setAction(title: GetPhotoSelection.album.title, style: .default) { self.showGetPhotoView(selection: .album) }
      .setAction(title: GetPhotoSelection.web.title, style: .default)
      .setCancelAction()
    
    present(alert, animated: true)
  }
  
  private func showGetPhotoView(selection: GetPhotoSelection) {
    guard !(selection == .web) else { return }
    
    let imagePicker = UIImagePickerController().configured {
      $0.delegate = self
      if selection == .camera { $0.sourceType = .camera }
    }
    
    present(imagePicker, animated: true)
  }
  
  // MARK: - Selector
  @objc private func cancelBarButtonTapped() {
    if titleText.isEmpty && memo.isEmpty {
      viewModel.dismiss()
    } else {
      viewModel.showContentDestructionAlert()
    }
  }
  
  @objc private func addBarButtonTapped() {
    viewModel.updateTitle(with: titleText)
    viewModel.updateMemo(with: memo)
    viewModel.add()
    viewModel.dismiss()
    
    if let image = photoImageView.image {
      viewModel.writeImage(
        image: image,
        router: .write(
          fileName: viewModel.object.id.stringValue,
          fileExtension: .jpg,
          level: .middle
        )
      )
    }
  }
  
  @objc private func textFieldDidChange() {
    updateAddButtonEnabled(isTitleEmpty: titleText.isEmpty)
  }
  
  @objc private func updateBoxButtonTapped() {
    viewModel.showUpdateBoxView()
  }
}

// MARK: - Image Picker Delegate
extension MakeTodoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[.originalImage] as? UIImage {
      photoImageView.image = pickedImage
    }
    
    dismiss(animated: true)
  }
}

// MARK: - Table Delegate
extension MakeTodoViewController: TableControllable {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return TodoConfiguration.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: TodoConfigTableViewCell.identifier,
      for: indexPath
    ) as! TodoConfigTableViewCell
    
    let data = viewModel.object
    let config = TodoConfiguration.allCases[indexPath.row]
    cell.updateUI(with: data, config: config)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let config = TodoConfiguration.allCases[indexPath.row]
    showUpdateConfigView(with: config)
  }
}

enum TodoConfiguration: Int, CaseIterable {
  
  case dutDate
  case flag
  case tag
  case priority
  case addImage
  
  var title: String {
    switch self {
      case .dutDate:
        return "마감일"
      case .flag:
        return "깃발"
      case .tag:
        return "태그"
      case .priority:
        return "우선 순위"
      case .addImage:
        return "이미지 추가"
    }
  }
  
  var row: Int {
    return self.rawValue
  }
}

enum GetPhotoSelection: Int, CaseIterable {
  
  case camera
  case album
  case web
  
  var title: String {
    switch self {
      case .camera:
        return "촬영하기"
      case .album:
        return "앨범에서 가져오기"
      case .web:
        return "웹에서 가져오기"
    }
  }
  
  var index: Int {
    return self.rawValue
  }
}

// MARK: - NotificationCenter
struct TodoNotification {
  private init() { }
  
  enum NameKey: String, NotificationNameKey {
    case updateConfig
  }
  
  enum InfoKey: String, NotificationInfoKey {
    case flag
    case priority
    case box
  }
  
  struct Info: NotificationInfo {
    var key: InfoKey
    var value: Any
  }
}

// MARK: - Value Transfer Delegate
protocol UpdateConfigDelegate {
  func tagsDidUpdate()
}

extension MakeTodoViewController: UpdateConfigDelegate {
  func tagsDidUpdate() {
    reloadConfig(with: .tag)
  }
}
