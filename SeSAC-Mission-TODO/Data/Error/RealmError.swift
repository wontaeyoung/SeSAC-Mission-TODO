//
//  RealmError.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/17/24.
//

import KazUtility

enum RealmError: AppError {
  case getRealmFailed
  case observedChangeError(error: Error)
  
  var logDescription: String {
    switch self {
      case .getRealmFailed:
        return "Realm 데이터베이스 객체를 생성하는데 실패했습니다."
        
      case .observedChangeError(let error):
        return "감지된 변경사항에서 에러가 발생했습니다. \(error.localizedDescription)"
    }
  }
  
  var alertDescription: String {
    switch self {
      case .getRealmFailed, .observedChangeError:
        return "정보를 가져오는데 실패했어요. 문제가 지속되면 개발자에게 문의해주세요."
    }
  }
}