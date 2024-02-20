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
    view.addSubview(collectonView)
  }
  
  override func setAttribute() {
    setToolbarItems(toolbar.items, animated: false)
    navigationController?.isToolbarHidden = false
  }
  
  override func setConstraint() {
    collectonView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    viewModel.observe { [weak self] _ in
      guard let self else { return }
      
      collectonView.reloadData()
      updateAddTodoButtonEnabled()
    }
  }
  
  // MARK: - Method
  private func updateAddTodoButtonEnabled() {
    addTodoButton.isEnabled = !viewModel.collection.isEmpty
  }
  
  // MARK: - Selector
  @objc private func addTodoButtonTapped() {
    viewModel.showMakeTodoView(makeTodoStyle: .add)
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
