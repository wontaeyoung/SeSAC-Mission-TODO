//
//  UpdateTodoBoxViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/21/24.
//

import UIKit
import KazUtility
import SnapKit

final class UpdateTodoBoxViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private let currentBoxCardView = CardView()
  
  private lazy var boxIconButton = UIButton().configured { button in
    button.configuration = .filled().configured {
      $0.buttonSize = .large
      $0.cornerStyle = .capsule
      $0.baseForegroundColor = .white
    }
  }
  
  private let boxNameLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 20, weight: .semibold)
    $0.textAlignment = .center
  }
  
  private let itemCreateInLabel = UILabel().configured {
    $0.text = "이 목록에 할 일이 추가됩니다."
    $0.font = .systemFont(ofSize: 11, weight: .regular)
    $0.textColor = .gray
    $0.textAlignment = .center
  }
  
  private lazy var tableView = UITableView().configured {
    $0.register(TodoBoxTableViewCell.self, forCellReuseIdentifier: TodoBoxTableViewCell.identifier)
    $0.delegate = self
    $0.dataSource = self
  }
  
  // MARK: - Property
  let viewModel: MakeTodoViewModel
  private var selectedRow: Int
  
  // MARK: - Initializer
  init(viewModel: MakeTodoViewModel) {
    self.viewModel = viewModel
    self.selectedRow = viewModel.fetchTodoBox().firstIndex(of: viewModel.currentBox) ?? 0
    super.init()
    
    updateUI(with: viewModel.currentBox)
  }
  
  // MARK: - Life Cycle
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationManager.shared.post(key: TodoNotification.NameKey.updateConfig, with: [
      TodoNotification.Info(key: .box, value: viewModel.currentBox)
    ])
  }
  
  override func setHierarchy() {
    view.addSubviews(currentBoxCardView, tableView)
    currentBoxCardView.addSubviews(boxIconButton, boxNameLabel, itemCreateInLabel)
  }
  
  override func setConstraint() {
    currentBoxCardView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.horizontalEdges.equalTo(view).inset(16)
    }
    
    boxIconButton.snp.makeConstraints { make in
      make.top.equalTo(currentBoxCardView).inset(16)
      make.centerX.equalTo(currentBoxCardView)
    }
    
    boxNameLabel.snp.makeConstraints { make in
      make.top.equalTo(boxIconButton.snp.bottom).offset(16)
      make.horizontalEdges.equalTo(currentBoxCardView).inset(16)
    }
    
    itemCreateInLabel.snp.makeConstraints { make in
      make.top.equalTo(boxNameLabel.snp.bottom).offset(8)
      make.horizontalEdges.equalTo(currentBoxCardView).inset(16)
      make.bottom.equalTo(currentBoxCardView).inset(16)
    }
    
    tableView.snp.makeConstraints { make in
      make.top.equalTo(currentBoxCardView.snp.bottom).offset(16)
      make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: - Method
  private func updateUI(with data: TodoBox) {
    guard let icon = data.icon else { return }
    let image = UIImage(systemName: icon.symbol)
    let color = UIColor(hex: icon.color)
    
    boxIconButton.configuration?.configure {
      $0.image = image
      $0.baseBackgroundColor = color
    }
    
    boxNameLabel.text = data.name
    boxNameLabel.textColor = color
  }
}

extension UpdateTodoBoxViewController: TableControllable {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.fetchTodoBox().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TodoBoxTableViewCell.identifier, for: indexPath) as! TodoBoxTableViewCell
    let data = viewModel.fetchTodoBox()[indexPath.row]
    
    cell.updateUI(with: data, showCountHidden: true)
    cell.accessoryType = indexPath.row == selectedRow ? .checkmark : .none
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedRow = indexPath.row
    let selectedBox = viewModel.fetchTodoBox()[selectedRow]
    
    viewModel.updateBox(with: selectedBox)
    updateUI(with: selectedBox)
    tableView.reloadData()
  }
}
