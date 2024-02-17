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

enum TodoConfiguration: String, CaseIterable {
  
  case dutDate = "마감일"
  case tag = "태그"
  case flag = "깃발"
  case priority = "우선 순위"
  case addImage = "이미지 추가"
  
  var title: String {
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
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
    $0.spellCheckingType = .no
  }
  
  private lazy var configTableView = UITableView().configured {
    $0.keyboardDismissMode = .onDrag
    $0.register(TodoConfigTableViewCell.self, forCellReuseIdentifier: TodoConfigTableViewCell.identifier)
    $0.delegate = self
    $0.dataSource = self
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
  
  private func updateAddButtonEnabled(isTitleEmpty: Bool) {
    navigationItem.rightBarButtonItem?.isEnabled = !isTitleEmpty
  }
}

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
    
    switch config {
      case .dutDate:
        viewModel.showUpdateDueDateView { [weak self] date in
          guard let self else { return }
          
          viewModel.updateDueDate(with: date)
        }
        
      default:
        break
    }
  }
}
