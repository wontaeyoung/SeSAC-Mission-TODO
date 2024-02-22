//
//  BoxTodoListViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/21/24.
//

import UIKit
import KazUtility
import SnapKit

final class BoxTodoListViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var tableView = UITableView().configured {
    let cellType = TodoTableViewCell.self
    $0.register(cellType, forCellReuseIdentifier: cellType.identifier)
    $0.delegate = self
    $0.dataSource = self
  }
  
  // MARK: - Property
  let viewModel: BoxTodoListViewModel
  
  // MARK: - Initializer
  init(viewModel: BoxTodoListViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubview(tableView)
  }
  
  override func setAttribute() {
    setBarItems()
  }
  
  override func setConstraint() {
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    viewModel.observe { result in
      self.tableView.reloadData()
    }
  }
  
  // MARK: - Method
  private func setBarItems() {
    let updateBox = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(updateBoxButtonTapped))
    let addItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTodoButtonTapped))
    
    navigationItem.rightBarButtonItems = [updateBox, addItem]
  }
  
  // MARK: - Selector
  @objc private func addTodoButtonTapped() {
    viewModel.showMakeTodoView()
  }
  
  @objc private func updateBoxButtonTapped() {
    viewModel.showUpdateBoxView()
  }
}

extension BoxTodoListViewController: TableControllable {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.object.items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as! TodoTableViewCell
    let row: Int = indexPath.row
    let data = viewModel.object.items[row]
    
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.showUpdateTodoView(row: indexPath.row)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    
    let data = viewModel.object.items[indexPath.row]
    viewModel.deleteItem(with: data)
  }
}
