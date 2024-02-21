//
//  TodoBoxTableViewCell.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/20/24.
//

import UIKit
import KazUtility
import SnapKit

final class TodoBoxTableViewCell: BaseTableViewCell {
  
  // MARK: - UI
  private lazy var iconButton = UIButton().configured {
    $0.configuration = .filled().configured {
      $0.buttonSize = .medium
      $0.cornerStyle = .capsule
      $0.preferredSymbolConfigurationForImage = .init(pointSize: 12)
      $0.baseForegroundColor = .white
    }
  }
  
  private let titleLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 15, weight: .semibold)
  }
  
  private let itemCountLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 15, weight: .semibold)
    $0.textAlignment = .right
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(iconButton, titleLabel, itemCountLabel)
  }
  
  override func setConstraint() {
    iconButton.snp.makeConstraints { make in
      make.leading.equalTo(contentView).inset(8)
      make.centerY.equalTo(contentView)
      make.size.equalTo(30)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(iconButton.snp.trailing).offset(16)
      make.centerY.equalTo(contentView)
    }
    
    itemCountLabel.snp.makeConstraints { make in
      make.leading.equalTo(titleLabel.snp.trailing).offset(16)
      make.trailing.equalTo(contentView).inset(8)
      make.centerY.equalTo(contentView)
    }
  }
  
  // MARK: - Method
  func updateUI(with data: TodoBox, showCountHidden: Bool = false) {
    guard let icon = data.icon else { return }
    
    iconButton.configuration?.configure {
      $0.image = UIImage(systemName: icon.symbol)
      $0.baseBackgroundColor = UIColor(hex: icon.color)
    }
    
    titleLabel.text = data.name
    itemCountLabel.text = "\(data.items.count)"
    itemCountLabel.isHidden = showCountHidden
  }
}
