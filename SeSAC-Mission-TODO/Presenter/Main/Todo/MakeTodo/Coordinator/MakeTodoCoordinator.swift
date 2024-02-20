//
//  MakeTodoCoordinator.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/18/24.
//

import UIKit
import KazUtility
import RealmSwift

final class MakeTodoCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  var modalNavigationController: UINavigationController?
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    
  }
}

extension MakeTodoCoordinator {
  
  func presentMakeTodoView(makeTodoStyle: MakeTodoStyle) {
    let repository = LiveTodoItemRepository()
    let viewModel = MakeTodoViewModel(coordinator: self, repository: repository, makeTodoStyle: makeTodoStyle)
    let viewController = MakeTodoViewController(viewModel: viewModel)
      .navigationTitle(with: makeTodoStyle.title, displayMode: .never)
      .hideBackTitle()
    
    self.modalNavigationController = UINavigationController(rootViewController: viewController)
    
    guard let modalNavigationController else { return }
    present(modalNavigationController, style: .fullScreen)
  }
  
  private func pushWithModalController(_ viewController: UIViewController) {
    guard let modalNavigationController else { return }
    
    modalNavigationController.pushViewController(viewController, animated: true)
  }
  
  func showUpdateDueDateView(current date: Date, config: TodoConfiguration, updateDateAction: @escaping (Date) -> Void) {
    let viewController = UpdateDueDateViewController(current: date, updateDateAction: updateDateAction)
      .navigationTitle(with: config.title, displayMode: .never)
    
    pushWithModalController(viewController)
  }
  
  func showUpdateFlagView(current isOn: Bool, config: TodoConfiguration) {
    let viewController = UpdateFlagViewController(current: isOn)
      .navigationTitle(with: config.title, displayMode: .never)
    
    pushWithModalController(viewController)
  }
  
  func showUpdateTagView(config: TodoConfiguration, tags: List<TodoTag>, delegate: any UpdateConfigDelegate) {
    let repository = LiveTodoTagRepository()
    let viewController = UpdateTagViewController(repository: repository, tags: tags, delegate: delegate)
      .navigationTitle(with: config.title, displayMode: .never)
    
    viewController.coordinator = self
    
    pushWithModalController(viewController)
  }
  
  func showUpdatePriorityView(current priority: Int, config: TodoConfiguration) {
    let viewController = UpdatePriorityViewController(current: priority)
      .navigationTitle(with: config.title, displayMode: .never)
    
    pushWithModalController(viewController)
  }
}
