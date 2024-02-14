//
//  CardView.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/15/24.
//

import UIKit
import KazUtility
import SnapKit

final class CardView: BaseView {
  
  override func setAttribute() {
    self.layer.cornerRadius = 15
    self.backgroundColor = .gray.withAlphaComponent(0.2)
  }
}
