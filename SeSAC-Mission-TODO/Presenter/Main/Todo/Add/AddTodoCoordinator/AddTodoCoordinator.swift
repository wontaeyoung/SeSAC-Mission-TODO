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
    present(modalNavigationController, style: .fullScreen)
  }
  
  func showUpdateDueDateView(current date: Date, config: TodoConfiguration, updateDateAction: @escaping (Date) -> Void) {
    let viewController = UpdateDueDateViewController(current: date, updateDateAction: updateDateAction)
      .navigationTitle(with: config.title, displayMode: .never)
    
    guard let modalNavigationController else { return }
    modalNavigationController.pushViewController(viewController, animated: true)
  }
  
  func showUpdateFlagView(current isOn: Bool, config: TodoConfiguration) {
    let viewController = UpdateFlagViewController(current: isOn)
      .navigationTitle(with: config.title, displayMode: .never)
    
    guard let modalNavigationController else { return }
    modalNavigationController.pushViewController(viewController, animated: true)
  }
}
