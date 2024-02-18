//
//  AddTodoCoordinator.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/18/24.
//

import UIKit
import KazUtility

final class AddTodoCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  var modalNavigationController: UINavigationController?
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    presentAddTodoView()
  }
}

extension AddTodoCoordinator {
  
  func presentAddTodoView() {
    let repository = LiveTodoItemRepository()
    let viewModel = AddTodoViewModel(coordinator: self, repository: repository)
    let viewController = AddTodoViewController(viewModel: viewModel)
      .navigationTitle(with: "새로운 할 일", displayMode: .never)
      .hideBackTitle()
    
    self.modalNavigationController = UINavigationController(rootViewController: viewController)
    
    guard let modalNavigationController else { return }
    present(modalNavigationController)
  }
  
  func showUpdateDueDateView(current: Date, updateDateAction: @escaping (Date) -> Void) {
    let viewController = UpdateDueDateViewController(current: current, updateDateAction: updateDateAction)
      .navigationTitle(with: "마감일", displayMode: .never)
    
    guard let modalNavigationController else { return }
    modalNavigationController.pushViewController(viewController, animated: true)
  }
}
