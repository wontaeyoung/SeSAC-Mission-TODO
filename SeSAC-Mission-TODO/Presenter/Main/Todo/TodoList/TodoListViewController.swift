//
//  TodoListViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/16/24.
//

import UIKit
import KazUtility
import SnapKit

enum TodoSortSelection: Int, CaseIterable {
  
  case title
  case dueDate
  case priority
  
  var title: String {
    switch self {
      case .title:
        return "제목"
      case .dueDate:
        return "마감일"
      case .priority:
        return "우선순위"
    }
  }
  
  var index: Int {
    return self.rawValue
  }
  
  var sortKey: TodoItem.Column {
    switch self {
      case .title:
        return .title
      case .dueDate:
        return .dueDate
      case .priority:
        return .priority
    }
  }
}

final class TodoListViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var tableView = UITableView().configured {
    $0.delegate = self
    $0.dataSource = self
    $0.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
    $0.showsVerticalScrollIndicator = false
  }
  
  private lazy var sortPullDownButton = UIButton().configured {
    $0.setImage(UIImage(systemName: "ellipsis.circle.fill"), for: .normal)
    $0.addTarget(self, action: #selector(sortPullDownButtonTapped), for: .touchUpInside)
  }
  
  // MARK: - Property
  let viewModel: TodoListViewModel
  
  // MARK: - Initializer
  init(viewModel: TodoListViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubview(tableView)
  }
  
  override func setAttribute() {
    setRightBarButtons()
  }
  
  override func setConstraint() {
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    viewModel.observe { results in
      self.tableView.reloadData()
    }
  }
  
  // MARK: - Method
  private func setRightBarButtons() {
    let dateFilter = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(dateFilterButtonTapped))
    let sort = UIBarButtonItem(customView: sortPullDownButton)
    
    navigationItem.rightBarButtonItems = [sort, dateFilter]
  }
  
  private func makeSortMenu() -> UIMenu {
    let menuItems: [UIAction] = TodoSortSelection.allCases.map { selection in
      return UIAction(title: selection.title) { [weak self] _ in
        guard let self else { return }
        
        viewModel.sortCollectionBy(selection)
        tableView.reloadData()
      }
    }
    
    return UIMenu(title: "정렬하기", children: menuItems)
  }
  
  // MARK: - Selector
  @objc private func dateFilterButtonTapped() {
    viewModel.showDueDateFilterSheet()
  }
  
  @objc private func sortPullDownButtonTapped(_ sender: UIButton) {
    sender.showsMenuAsPrimaryAction = true
    sender.menu = makeSortMenu()
  }
}

extension TodoListViewController: TableControllable {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.collection.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as! TodoTableViewCell
    
    let row: Int = indexPath.row
    let data = viewModel.collection[row]
    
    if let imageData = viewModel.loadImage(router: .read(fileName: data.id.stringValue, fileExtension: .jpg)) {
      cell.updateUI(with: data, image: UIImage(data: imageData))
    } else {
      cell.updateUI(with: data, image: nil)
    }
    
    cell.checkboxUpdateAction = { [weak self] in
      guard let self else { return }
      
      viewModel.updateIsDone(with: data)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    
    let data = viewModel.collection[indexPath.row]
    viewModel.deleteItem(with: data)
  }
}
