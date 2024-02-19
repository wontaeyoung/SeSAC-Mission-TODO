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
  private lazy var tagButton = UIButton().configured {
    $0.addTarget(self, action: #selector(tagButtonTapped), for: .touchUpInside)
  }
  
  // MARK: - Property
  var updateTagAction: (() -> Void)?
  
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
  func updateUI(with data: String, isTagging: Bool, row: Int) {
    let config: UIButton.Configuration = isTagging ? .filled() : .gray()
    
    tagButton.configuration = config.configured {
      $0.title = "#\(data)"
      $0.titleLineBreakMode = .byTruncatingTail
      $0.buttonSize = .small
      $0.cornerStyle = .small
    }
    
    tagButton.tag = row
  }
  
  // MARK: - Selector
  @objc private func tagButtonTapped() {
    updateTagAction?()
  }
}
