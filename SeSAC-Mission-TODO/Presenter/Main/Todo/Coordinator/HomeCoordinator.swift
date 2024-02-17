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
    let repository = LiveTodoItemRepository()
    let viewModel = HomeViewModel(coordinator: self, repository: repository)
    let viewController = HomeViewController(viewModel: viewModel)
      .navigationTitle(with: "전체", displayMode: .always)
    
    self.push(viewController)
  }
  
  func combineAddTodoFlow() {
    let coordinator = AddTodoCoordinator(self.navigationController)
    self.addChild(coordinator)
    
    coordinator.start()
  }
}
