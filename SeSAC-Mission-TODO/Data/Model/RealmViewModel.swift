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
  var bindAction: ((Results<ObjectType>) -> Void)? { get set }
  var notificationToken: NotificationToken? { get set }
  
  func observe(_ action: @escaping (Results<ObjectType>) -> Void)
}

extension RealmViewModel {
  func observe(_ action: @escaping (Results<ObjectType>) -> Void) {
    action(model)
    self.notificationToken = model.observe { [weak self] (changes: RealmCollectionChange) in
    self.bindAction = action
      guard let self else { return }
      
      switch changes {
        case .initial, .update:
          bindAction?(model)
          
        case .error(let error):
          LogManager.shared.log(with: RealmError.observedChangeError(error: error), to: .local)
      }
    }
  }
}
