//
//  TodoConfigTableViewCell.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/15/24.
//

import UIKit
import KazUtility
import SnapKit

final class TodoConfigTableViewCell: BaseTableViewCell {
  
  // MARK: - UI
  private let titleLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 17, weight: .bold)
  }
  private let contentLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.textAlignment = .right
    $0.textColor = .gray
  }
  
  // MARK: - Initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  override func setHierarchy() {
    contentView.addSubviews(titleLabel, contentLabel)
  }
  
  override func setAttribute() {
    accessoryType = .disclosureIndicator
  }
  
  override func setConstraint() {
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(contentView).inset(8)
      make.centerY.equalTo(contentView)
      make.width.equalTo(100)
    }
    
    contentLabel.snp.makeConstraints { make in
      make.leading.equalTo(titleLabel.snp.trailing).offset(8)
      make.trailing.equalTo(contentView).inset(8)
      make.centerY.equalTo(contentView)
    }
  }
  
  // MARK: - Method
  func updateUI(with data: TodoItem, config: TodoConfiguration) {
    titleLabel.text = config.title
    
    switch config {
      case .dutDate:
        contentLabel.text = DateFormatManager.shared.toString(with: data.dueDate, formatString: "yyyy-MM-dd")
      
      case .flag:
        contentLabel.text = data.isFlag ? "On" : "Off"
        
      case .tag:
        contentLabel.text = data.tags
          .map { "#" + $0.name }
          .joined(separator: " ")
      
      case .priority:
        contentLabel.text = data.todoPriority.title
        
      case .addImage:
        contentLabel.text = ""
    }
  }
}
