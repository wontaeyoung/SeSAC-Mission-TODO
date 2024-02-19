//
//  AddTodoViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/15/24.
//

import UIKit
import KazUtility
import SnapKit
import RealmSwift

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

final class AddTodoViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private let cardView = CardView()
  private lazy var titleTextField = UITextField().configured {
    $0.placeholder = "제목"
    $0.borderStyle = .none
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
    $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
  }
  private let divider = Divider()
  private let memoTextView = UITextView().configured {
    $0.backgroundColor = .clear
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
  }
  
  private lazy var configTableView = UITableView().configured {
    $0.keyboardDismissMode = .onDrag
    $0.register(TodoConfigTableViewCell.self, forCellReuseIdentifier: TodoConfigTableViewCell.identifier)
    $0.delegate = self
    $0.dataSource = self
    $0.isScrollEnabled = false
  }
  
  // MARK: - Property
  let viewModel: AddTodoViewModel
  
  private var titleText: String {
    return titleTextField.text ?? ""
  }
  
  private var memo: String {
    return memoTextView.text ?? ""
  }
  
  // MARK: - Initialzier
  init(viewModel: AddTodoViewModel) {
    self.viewModel = viewModel
    
    super.init()
    
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
    }
  }
  
  deinit {
    NotificationManager.shared.remove(self)
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(cardView, configTableView)
    cardView.addSubviews(titleTextField, divider, memoTextView)
  }
  
  override func setAttribute() {
    setNavigationItems()
  }
  
  override func setConstraint() {
    cardView.snp.makeConstraints { make in
      make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
    }
    
    titleTextField.snp.makeConstraints { make in
      make.top.horizontalEdges.equalTo(cardView).inset(8)
    }
    
    divider.snp.makeConstraints { make in
      make.top.equalTo(titleTextField.snp.bottom).offset(8)
      make.horizontalEdges.equalTo(cardView).inset(8)
    }
    
    memoTextView.snp.makeConstraints { make in
      make.top.equalTo(divider.snp.bottom).offset(8)
      make.bottom.horizontalEdges.equalTo(cardView).inset(8)
      make.height.equalTo(150)
    }
    
    configTableView.snp.makeConstraints { make in
      make.top.equalTo(cardView.snp.bottom).offset(8)
      make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
    }
  }
  
  // MARK: - Method
  private func setNavigationItems() {
    let cancelBarButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelBarButtonTapped))
    let addBarButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addBarButtonTapped))
    
    navigationItem.leftBarButtonItem = cancelBarButton
    navigationItem.rightBarButtonItem = addBarButton
    
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
    }
  }
  
  private func reloadConfig(with config: TodoConfiguration) {
    configTableView.reloadRow(row: config.row)
  }
  
  // MARK: - Selector
  @objc private func cancelBarButtonTapped() {
    viewModel.dismiss()
  }
  
  @objc private func addBarButtonTapped() {
    viewModel.updateTitle(with: titleText)
    viewModel.updateMemo(with: memo)
    viewModel.add()
    viewModel.dismiss()
  }
  
  @objc private func textFieldDidChange() {
    updateAddButtonEnabled(isTitleEmpty: titleText.isEmpty)
  }
}

// MARK: - Table Delegate
extension AddTodoViewController: TableControllable {
  
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

// MARK: - NotificationCenter
struct TodoNotification {
  private init() { }
  
  enum NameKey: String, NotificationNameKey {
    case updateConfig
  }
  
  enum InfoKey: String, NotificationInfoKey {
    case flag
    case priority
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

extension AddTodoViewController: UpdateConfigDelegate {
  func tagsDidUpdate() {
    reloadConfig(with: .tag)
  }
}
