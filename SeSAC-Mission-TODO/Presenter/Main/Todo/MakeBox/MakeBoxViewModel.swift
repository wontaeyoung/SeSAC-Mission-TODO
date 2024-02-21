//
//  MakeBoxViewModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/21/24.
//

import Foundation
import KazUtility
import RealmSwift

final class MakeBoxViewModel: RealmObjectViewModel {
  
  typealias ObjectType = TodoBox
  
  // MARK: - Property
  weak var coordinator: HomeCoordinator?
  private let repository: any TodoBoxRepository
  
  // MARK: - Model
  var object: ObjectType
  var bindAction: ((ObjectType) -> Void)?
  var notificationToken: NotificationToken?
  
  // MARK: - Initializer
  init(coordinator: HomeCoordinator? = nil, repository: any TodoBoxRepository, makeBoxStyle: MakeBoxStyle) {
    self.coordinator = coordinator
    self.repository = repository
    
    switch makeBoxStyle {
      case .add:
        self.object = .default
        
      case .update(let box):
        self.object = box
    }
  }
  
  deinit {
    notificationToken?.invalidate()
  }
  
  // MARK: - Method
  func add() {
    do {
      try repository.create(with: object)
    } catch {
      let error = RealmError.addFailed(error: error)
      LogManager.shared.log(with: error, to: .local)
      Task { await coordinator?.showErrorAlert(error: error) }
    }
  }
  
  func update(title: String, icon: BoxIcon) {
    do {
      try repository.update(with: object) { box in
        box.name = title
        box.icon = icon
      }
    } catch {
      let error = RealmError.updateFailed(error: error)
      LogManager.shared.log(with: error, to: .local)
      Task { await coordinator?.showErrorAlert(error: error) }
    }
  }
}

@MainActor
extension MakeBoxViewModel {
  func pop() {
    coordinator?.pop()
  }
}
