//
//  MakeTodoViewModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/15/24.
//

import UIKit
import KazUtility
import RealmSwift

final class MakeTodoViewModel: RealmObjectViewModel {
  
  typealias ObjectType = TodoItem
  
  // MARK: - Property
  weak var coordinator: MakeTodoCoordinator?
  private let repository: TodoItemRepository
  
  // MARK: - Model
  var object: TodoItem
  var bindAction: ((TodoItem) -> Void)?
  var notificationToken: NotificationToken?
  
  // MARK: - Initializer
  init(coordinator: MakeTodoCoordinator? = nil, repository: TodoItemRepository) {
    self.coordinator = coordinator
    self.repository = repository
    self.object = .empty
  }
  
  deinit {
    notificationToken?.invalidate()
  }
  
  // MARK: - Method
  func add() {
    do {
      try repository.create(with: object)
    } catch {
      let realmError: RealmError = .addFailed(error: error)
      LogManager.shared.log(with: realmError, to: .local)
      Task { await coordinator?.showErrorAlert(error: realmError) }
    }
  }
  
  func writeImage(image: UIImage, router: PhotoFileRouter) {
    guard let data = image.jpegData(compressionQuality: router.compressionPercent) else {
      LogManager.shared.log(with: FileManageError.imageToDataFailed, to: .local)
      Task { await coordinator?.showErrorAlert(error: FileManageError.imageToDataFailed) }
      return
    }
    
    /// 파일 경로에 디렉토리가 존재하지 않으면 생성
    if !router.directoryExist {
      do {
        try FileManager.default.createDirectory(at: router.directoryURL, withIntermediateDirectories: false)
      } catch {
        let directoryError: FileManageError = .createDirectoryFailed(error: error)
        LogManager.shared.log(with: directoryError, to: .local)
        Task { await coordinator?.showErrorAlert(error: directoryError) }
      }
    }
    
    do {
      try data.write(to: router.fileURL)
    } catch {
      let fileError: FileManageError = .writeDataFailed(error: error)
      LogManager.shared.log(with: fileError, to: .local)
      Task { await coordinator?.showErrorAlert(error: fileError) }
    }
  }
}

extension MakeTodoViewModel {
  
  func updateTitle(with title: String) {
    object.title = title
  }
  
  func updateMemo(with memo: String) {
    object.memo = memo
  }
  
  func updateDueDate(with date: Date) {
    object.dueDate = date
  }
  
  func updateFlag(with isFlag: Bool) {
    object.isFlag = isFlag
  }
  
  func updatePriority(with priority: Int) {
    object.priority = priority
  }
}

extension MakeTodoViewModel {
  
  @MainActor
  func dismiss() {
    coordinator?.dismiss()
  }
  
  @MainActor
  func showUpdateDueDateView(current date: Date, config: TodoConfiguration, updateDateAction: @escaping (Date) -> Void) {
    coordinator?.showUpdateDueDateView(current: date, config: config, updateDateAction: updateDateAction)
  }
  
  @MainActor
  func showUpdateFlagView(current isOn: Bool, config: TodoConfiguration) {
    coordinator?.showUpdateFlagView(current: isOn, config: config)
  }
  
  @MainActor
  func showUpdateTagView(config: TodoConfiguration, tags: List<TodoTag>, delegate: any UpdateConfigDelegate) {
    coordinator?.showUpdateTagView(config: config, tags: tags, delegate: delegate)
  }
  
  @MainActor
  func showUpdatePriorityView(current priority: Int, config: TodoConfiguration) {
    coordinator?.showUpdatePriorityView(current: priority, config: config)
  }
}
