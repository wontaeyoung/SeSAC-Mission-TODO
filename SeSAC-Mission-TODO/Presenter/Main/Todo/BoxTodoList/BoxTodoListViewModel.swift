//
//  BoxTodoListViewModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/21/24.
//

import Foundation
import KazUtility
import RealmSwift

final class BoxTodoListViewModel: RealmObjectViewModel {
  
  typealias ObjectType = TodoBox
  
  // MARK: - Property
  weak var coordinator: HomeCoordinator?
  private let repository: any TodoBoxRepository
  
  // MARK: - Model
  var object: ObjectType
  var bindAction: ((ObjectType) -> Void)?
  var notificationToken: NotificationToken?
  
  // MARK: - Initializer
  init(coordinator: HomeCoordinator? = nil, repository: any TodoBoxRepository, box: TodoBox) {
    self.coordinator = coordinator
    self.repository = repository
    self.object = box
  }
  
  deinit {
    notificationToken?.invalidate()
  }
  
  // MARK: - Method
  func loadImage(router: PhotoFileRouter) -> Data? {
    guard router.fileExist else { return nil }
    
    return FileManager.default.contents(atPath: router.filePath)
  }
  
  func updateIsDone(with data: TodoItem) {
    do {
      try repository.updateListItem(to: object, at: data) {
        $0.isDone.toggle()
      }
    } catch {
      let error: RealmError = .updateFailed(error: error)
      LogManager.shared.log(with: error, to: .local)
      Task { await coordinator?.showErrorAlert(error: error) }
    }
  }
  
  func deleteItem(with data: TodoItem) {
    do {
      try repository.deleteListItem(to: object, at: data)
    } catch {
      let error: RealmError = .updateFailed(error: error)
      LogManager.shared.log(with: error, to: .local)
      Task { await coordinator?.showErrorAlert(error: error) }
    }
  }
}

@MainActor
extension BoxTodoListViewModel {
  func showMakeTodoView() {
    coordinator?.combineMakeTodoFlow(makeTodoStyle: .add(box: object))
  }
  
  func showUpdateBoxView() {
    coordinator?.showMakeBoxView(makeBoxStyle: .update(box: object))
  }
  
  func showUpdateTodoView(row: Int) {
    coordinator?.combineMakeTodoFlow(makeTodoStyle: .update(todo: object.items[row]))
  }
}
