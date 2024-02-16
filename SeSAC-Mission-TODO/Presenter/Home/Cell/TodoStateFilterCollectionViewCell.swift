//
//  TodoStateFilterCollectionViewCell.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/15/24.
//

import UIKit
import KazUtility
import SnapKit

final class TodoStateFilterCollectionViewCell: BaseCollectionViewCell {
  
  // MARK: - UI
  private let cardView = CardView()
  private let iconButton = UIButton()
  private let countLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 24, weight: .bold)
    $0.textAlignment = .right
  }
  private let stateLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 15, weight: .bold)
    $0.textColor = .gray
    $0.textAlignment = .left
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubview(cardView)
    cardView.addSubviews(iconButton, countLabel, stateLabel)
  }
  
  override func setConstraint() {
    cardView.snp.makeConstraints { make in
      make.edges.equalTo(contentView)
    }
    
    iconButton.snp.makeConstraints { make in
      make.top.leading.equalTo(cardView).inset(12)
    }
    
    countLabel.snp.makeConstraints { make in
      make.top.trailing.equalTo(cardView).inset(12)
    }
    
    stateLabel.snp.makeConstraints { make in
      make.top.greaterThanOrEqualTo(iconButton).offset(12)
      make.bottom.leading.equalTo(cardView).inset(12)
    }
  }
  
  
  // MARK: - Method
  func updateUI(with data: TodoItem.State, count: Int) {
    iconButton.configuration = data.config
    countLabel.text = "\(count)"
    stateLabel.text = data.title
  }
}
