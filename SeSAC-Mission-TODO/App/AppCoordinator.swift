//
//  AppCoordinator.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/14/24.
//

import UIKit
import KazUtility

final class AppCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  private func setGlobalNavigationConfig() {
    navigationController.navigationBar.prefersLargeTitles = true
  }
  
  func start() {
    setGlobalNavigationConfig()
    connectHomeFlow()
  }
}

extension AppCoordinator {
  
  func connectHomeFlow() {
    let coordinator = HomeCoordinator(self.navigationController)
    coordinator.delegate = self
    self.addChild(coordinator)
    
    coordinator.start()
  }
}

extension AppCoordinator: CoordinatorDelegate {
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    
  }
}
