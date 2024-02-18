//
//  UITableView+.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/18/24.
//

import UIKit

extension UITableView {
  func reloadRow(row: Int, section: Int = 0) {
    self.reloadRows(at: [IndexPath(row: row, section: section)], with: .automatic)
  }
}
