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
  private let todoBoxRepository: any TodoBoxRepository
  private let todoItemRepository: any TodoItemRepository
  var makeTodoStyle: MakeTodoStyle
  
  // MARK: - Model
  var object: ObjectType
  var bindAction: ((ObjectType) -> Void)?
  var notificationToken: NotificationToken?
  var currentBox: TodoBox
  var tempObject: ObjectType
  
  // MARK: - Initializer
  init(coordinator: MakeTodoCoordinator? = nil, todoBoxRepository: any TodoBoxRepository, todoItemRepository: any TodoItemRepository, makeTodoStyle: MakeTodoStyle) {
    self.coordinator = coordinator
    self.todoBoxRepository = todoBoxRepository
    self.todoItemRepository = todoItemRepository
    self.makeTodoStyle = makeTodoStyle
    
    switch makeTodoStyle {
      case .add(let box):
        self.object = .empty
        self.currentBox = box
        
      case .update(let todo):
        self.object = todo
        self.currentBox = todo.box.first ?? .default
    }
    self.tempObject = object.copied
  }
  
  deinit {
    notificationToken?.invalidate()
  }
  
  // MARK: - Method
  func fetchTodoBox() -> Results<TodoBox> {
    return todoBoxRepository.fetch()
  }
  
  func add() {
    do {
      try todoBoxRepository.create(with: currentBox)
      try todoBoxRepository.append(with: tempObject, to: currentBox)
    } catch {
      let realmError: RealmError = .addFailed(error: error)
      LogManager.shared.log(with: realmError, to: .local)
      Task { await coordinator?.showErrorAlert(error: realmError) }
    }
  }
  
  func update() {
    do {
      try todoBoxRepository.updateListItem(to: currentBox, at: tempObject, updating: { _ in })
    } catch {
      let realmError: RealmError = .updateFailed(error: error)
      LogManager.shared.log(with: realmError, to: .local)
      Task { await coordinator?.showAlertWithModalController(title: "ASD", message: "ZXC") }
    }
  }
  
  func loadImage(router: PhotoFileRouter) -> Data? {
    guard router.fileExist else { return nil }
    
    return FileManager.default.contents(atPath: router.filePath)
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

// FIXME: -
/// 업데이트 화면에서는 수정이 트랜젝션에서 이뤄져야해서 레포지토리로 가져가서 update 안하면 런타임 에러 발생함
/// 24.02.23
/// 임시 오브젝트로 Realm 매니징 관계를 끊어서 트랜잭션 문제는 수정했지만, 기본 object 자체를 아예 안쓰기 때문에 구조상 문제가 있음
/// Realm 객체를 DTO로 분리해서 매니징에서 오는 문제 수정이 필요함
extension MakeTodoViewModel {
  
  func updateTitle(with title: String) {
    tempObject.title = title
  }
  
  func updateMemo(with memo: String) {
    tempObject.memo = memo
  }
  
  func updateDueDate(with date: Date) {
    tempObject.dueDate = date
  }
  
  func updateFlag(with isFlag: Bool) {
    tempObject.isFlag = isFlag
  }
  
  func updatePriority(with priority: Int) {
    tempObject.priority = priority
  }
  
  func updateBox(with box: TodoBox) {
    currentBox = box
  }
}

extension MakeTodoViewModel {
  
  @MainActor
  func dismiss() {
    coordinator?.dismiss()
  }
  
  @MainActor
  func showContentDestructionAlert() {
    coordinator?.showAlertWithModalController(
      title: "작성한 내용이 사라져요!",
      message: "작성을 그만하고 돌아갈까요?",
      okStyle: .destructive,
      isCancelable: true
    ) {
      self.dismiss()
    }
  }
  
  @MainActor
  func showUpdateBoxView() {
    switch makeTodoStyle {
      case .add:
        coordinator?.showUpdateBoxView(makeTodoStyle: .add(box: currentBox))
        
      case .update:
        coordinator?.showUpdateBoxView(makeTodoStyle: .update(todo: object))   
    }
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
