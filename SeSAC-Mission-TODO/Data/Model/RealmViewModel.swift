//
//  RealmViewModel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/17/24.
//

import KazUtility
import RealmSwift

protocol RealmViewModel: ViewModel, AnyObject {
  
  associatedtype ObjectType: RealmModel
  
  var model: Results<ObjectType> { get }
  var observe: ((Results<ObjectType>) -> Void)? { get set }
  var notificationToken: NotificationToken? { get set }
  
  func subscribe(_ action: @escaping (Results<ObjectType>) -> Void)
}

extension RealmViewModel {
  func subscribe(_ action: @escaping (Results<ObjectType>) -> Void) {
    action(model)
    self.observe = action
    self.notificationToken = model.observe { [weak self] (changes: RealmCollectionChange) in
      guard let self else { return }
      
      switch changes {
        case .initial, .update:
          observe?(model)
          
        case .error(let error):
          LogManager.shared.log(with: RealmError.observedChangeError(error: error), to: .local)
      }
    }
  }
}
