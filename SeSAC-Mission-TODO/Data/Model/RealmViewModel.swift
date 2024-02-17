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
    self.bindAction = action
    
    /// observe와 subscribe 차이
    /// observe
    /// - 로컬 Realm DB에서 객체 혹은 컬렉션 변화 감지 목적으로 설계
    /// - 데이터 추가, 수정, 삭제, 에러에 대한 이벤트 콜백을 받아서 로직 실행 가능
    /// subscribe
    /// - 주로 Realm Sync와 함께 사용하여 서버 데이터 변화를 감지하는 목적으로 설계
    /// - 네트워크를 통한 데이터 동기화로 서버와 클라이언트 데이터 일치에 중점
    /// - 로컬 DB에 대해서도 사용은 가능하지만 observe보다 성능 측면에서 효율적이지 않을 수 있음
    /// - 서버 동기화 목적에 맞게 네트워크 통신과 같은 오버헤드가 있을 수 있으며, 직관적이지 않고 더 복잡할 수 있음
    self.notificationToken = model.observe { [weak self] changes in
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
