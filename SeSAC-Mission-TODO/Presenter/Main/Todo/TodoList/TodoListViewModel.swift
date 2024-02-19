//
//  TodoListViewModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/16/24.
//

import Foundation
import KazUtility
import RealmSwift

final class TodoListViewModel: RealmCollectionViewmodel {
  
  typealias ObjectType = TodoItem
  
  // MARK: - Property
  weak var coordinator: HomeCoordinator?
  
  // MARK: - Model
  let collection: Results<TodoItem>
  var bindAction: ((Results<TodoItem>) -> Void)?
  var notificationToken: NotificationToken?
  
  // MARK: - Initializer
  init(coordinator: HomeCoordinator? = nil, collection: Results<TodoItem>) {
    self.coordinator = coordinator
    self.collection = collection
  }
  
  deinit {
    notificationToken?.invalidate()
  }
  
  // MARK: - Method
  func loadImage(router: PhotoFileRouter) -> Data? {
    guard router.fileExist else { return nil }
    
    return FileManager.default.contents(atPath: router.filePath)
  }
}

