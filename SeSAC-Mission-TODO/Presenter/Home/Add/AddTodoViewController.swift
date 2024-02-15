//
//  AddTodoViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/15/24.
//

import UIKit
import KazUtility
import SnapKit

enum TodoConfiguration: String, CaseIterable {
  
  case dutDate = "마감일"
  case tag = "태그"
  case priority = "우선 순위"
  case addImage = "이미지 추가"
  
  var title: String {
    return self.rawValue
  }
}
