//
//  HomeCoordinator.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/14/24.
//

import UIKit
import KazUtility

final class HomeCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showHomeView()
  }
}

extension HomeCoordinator {
  
  func showHomeView() {
    let viewModel = HomeViewModel(coordinator: self)
    let viewController = HomeViewController(viewModel: viewModel)
      .navigationTitle(with: "전체", displayMode: .always)
    
    self.push(viewController)
  }
  
  func showAddTodoView() {
    let viewModel = AddTodoViewModel(coordinator: self)
    let viewController = AddTodoViewController(viewModel: viewModel)
      .navigationTitle(with: "새로운 할 일", displayMode: .never)
    
    self.present(viewController)
  }
}
