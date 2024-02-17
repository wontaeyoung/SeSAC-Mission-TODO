//
//  Divider.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/15/24.
//

import UIKit
import KazUtility

final class Divider: BaseView {
  
  override func setAttribute() {
    self.backgroundColor = .lightGray
  }
  
  override func setConstraint() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
  }
}

