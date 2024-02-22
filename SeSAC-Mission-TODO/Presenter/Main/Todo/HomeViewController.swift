//
//  HomeViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/14/24.
//

import UIKit
import KazUtility
import SnapKit

final class HomeViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var collectonView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionLayout()).configured {
    $0.register(TodoStateFilterCollectionViewCell.self, forCellWithReuseIdentifier: TodoStateFilterCollectionViewCell.identifier)
    $0.delegate = self
    $0.dataSource = self
  }
  
  private let boxListTitleLabel = UILabel().configured {
    $0.text = "나의 목록"
    $0.font = .systemFont(ofSize: 20, weight: .semibold)
  }
  
  private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).configured {
    $0.register(TodoBoxTableViewCell.self, forCellReuseIdentifier: TodoBoxTableViewCell.identifier)
    $0.delegate = self
    $0.dataSource = self
    $0.showsVerticalScrollIndicator = false
  }
  
  private lazy var addTodoButton = UIButton().configured { button in
    button.configuration = .plain().configured {
      $0.title = "새로운 할 일"
      $0.image = UIImage(systemName: "plus.circle.fill")
      $0.imagePadding = 8
    }
    
    button.addTarget(self, action: #selector(addTodoButtonTapped), for: .touchUpInside)
  }
  
  private lazy var toolbar = UIToolbar().configured {
    let addTodo = UIBarButtonItem(customView: addTodoButton)
    let addList = UIBarButtonItem(title: "목록 추가", style: .plain, target: self, action: #selector(addListBarButtonTapped))
    let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    $0.setItems([addTodo, spaceItem, addList], animated: false)
  }
  
  // MARK: - Property
  let viewModel: HomeViewModel
  
  // MARK: - Initializer
  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(collectonView, boxListTitleLabel, tableView)
  }
  
  override func setAttribute() {
    setToolbarItems(toolbar.items, animated: false)
    navigationController?.isToolbarHidden = false
  }
  
  override func setConstraint() {
    collectonView.snp.makeConstraints { make in
      make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
    }
    
    boxListTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(collectonView.snp.bottom).offset(16)
      make.horizontalEdges.equalTo(view).inset(20)
    }
    
    tableView.snp.makeConstraints { make in
      make.top.equalTo(boxListTitleLabel.snp.bottom).offset(16)
      make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    viewModel.observe { [weak self] _ in
      guard let self else { return }
      
      tableView.reloadData()
      collectonView.reloadData()
      updateAddTodoButtonEnabled()
      updateBoxListHeaderLabelHidden()
    }
  }
  
  // MARK: - Method
  private func updateBoxListHeaderLabelHidden() {
    boxListTitleLabel.isHidden = viewModel.collection.isEmpty
  }
  
  private func updateAddTodoButtonEnabled() {
    addTodoButton.isEnabled = !viewModel.collection.isEmpty
  }
  
  // MARK: - Selector
  @objc private func addTodoButtonTapped() {
    guard let firstBox = viewModel.collection.first else { return }
    
    viewModel.showMakeTodoView(makeTodoStyle: .add(box: firstBox))
  }
  
  @objc private func addListBarButtonTapped() {
    viewModel.showMakeBoxView(makeBoxStyle: .add)
  }
}

extension HomeViewController: CollectionControllable {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return TodoItem.State.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: TodoStateFilterCollectionViewCell.identifier,
      for: indexPath
    ) as! TodoStateFilterCollectionViewCell
    
    let data = TodoItem.State.allCases[indexPath.row]
    let count: Int = viewModel.filteredCount(by: data)
    cell.updateUI(with: data, count: count)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let data = TodoItem.State.allCases[indexPath.row]
    viewModel.showTodoListView(state: data)
  }
  
  private func setCollectionLayout() -> UICollectionViewFlowLayout {
    return UICollectionViewFlowLayout().configured {
      let cellItemInset: CGFloat = 10
      let padding: CGFloat = 16
      let width = UIScreen.main.bounds.width - cellItemInset - padding * 2
      
      $0.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
      $0.itemSize = CGSize(width: width / 2, height: 80)
      $0.minimumLineSpacing = cellItemInset
      $0.minimumInteritemSpacing = cellItemInset
      $0.scrollDirection = .vertical
    }
  }
}

extension HomeViewController: TableControllable {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.collection.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TodoBoxTableViewCell.identifier, for: indexPath) as! TodoBoxTableViewCell
    let data = viewModel.collection[indexPath.row]
    
    cell.updateUI(with: data)
    cell.backgroundConfiguration = .listGroupedCell()
    cell.accessoryType = .disclosureIndicator
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = viewModel.collection[indexPath.row]
    viewModel.showBoxTodoListView(with: data)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView()
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }
}
