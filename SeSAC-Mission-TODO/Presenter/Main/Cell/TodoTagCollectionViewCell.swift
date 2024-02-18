//
//  TodoTagCollectionViewCell.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/18/24.
//

import UIKit
import KazUtility
import SnapKit

final class TodoTagCollectionViewCell: BaseCollectionViewCell {
  
  // MARK: - UI
  private let tagButton = UIButton().configured { button in
    button.configuration = .filled().configured {
      $0.buttonSize = .mini
      $0.cornerStyle = .medium
    }
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubview(tagButton)
  }
  
  override func setConstraint() {
    tagButton.snp.makeConstraints { make in
      make.edges.equalTo(contentView)
    }
  }
  
  // MARK: - Method
  func updateUI(with data: String) {
    tagButton.configuration?.title = "#\(data)"
  }
}

