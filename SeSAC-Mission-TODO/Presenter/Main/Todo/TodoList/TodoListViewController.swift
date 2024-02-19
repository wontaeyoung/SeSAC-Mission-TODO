//
//  TodoListViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/16/24.
//

import UIKit
import KazUtility
import SnapKit

final class TodoListViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var tableView = UITableView().configured {
    $0.delegate = self
    $0.dataSource = self
    $0.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
    $0.showsVerticalScrollIndicator = false
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
  
  override func setConstraint() {
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension TodoListViewController: TableControllable {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.collection.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as! TodoTableViewCell
    
    let data = viewModel.collection[indexPath.row]
    
    if let imageData = viewModel.loadImage(router: .read(fileName: data.id.stringValue, fileExtension: .jpg)) {
      cell.updateUI(with: data, image: UIImage(data: imageData))
    } else {
      cell.updateUI(with: data, image: nil)
    }
    
    return cell
  }
}
