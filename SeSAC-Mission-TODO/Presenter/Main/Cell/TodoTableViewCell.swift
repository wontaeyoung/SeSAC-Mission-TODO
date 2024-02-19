//
//  TodoTableViewCell.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/16/24.
//

import UIKit
import KazUtility
import SnapKit

final class TodoTableViewCell: BaseTableViewCell {
  
  // MARK: - UI
  private let titleLabel = UILabel().configured { $0.font = .systemFont(ofSize: 15, weight: .bold) }
  private let memoLabel = UILabel().configured { $0.font = .systemFont(ofSize: 13, weight: .regular) }
  private let priorityLabel = UILabel().configured { $0.font = .systemFont(ofSize: 13, weight: .semibold) }
  private let tagLabel = UILabel().configured {
    $0.textColor = .gray
    $0.font = .systemFont(ofSize: 13, weight: .regular)
  }
  private let dueDateLabel = UILabel().configured {
    $0.textAlignment = .right
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
  }
  private let photoImageView = UIImageView().configured { $0.contentMode = .scaleAspectFit }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(
      titleLabel, dueDateLabel,
      memoLabel, photoImageView,
      priorityLabel,
      tagLabel
    )
  }
  
  override func setConstraint() {
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(contentView).inset(8)
      make.leading.equalTo(contentView).inset(16)
    }
    
    dueDateLabel.snp.makeConstraints { make in
      make.top.equalTo(contentView).inset(8)
      make.trailing.equalTo(contentView).inset(16)
    }
    
    memoLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.leading.equalTo(contentView).inset(16)
      make.trailing.equalTo(photoImageView.snp.leading).offset(-8)
    }
    
    photoImageView.snp.makeConstraints { make in
      make.top.equalTo(dueDateLabel.snp.bottom).offset(8)
      make.trailing.equalTo(contentView).inset(16)
      make.size.equalTo(44)
    }
    
    priorityLabel.snp.makeConstraints { make in
      make.top.equalTo(memoLabel.snp.bottom).offset(8)
      make.leading.equalTo(contentView).inset(16)
      make.trailing.equalTo(photoImageView.snp.leading).offset(-8)
    }
    
    tagLabel.snp.makeConstraints { make in
      make.top.equalTo(priorityLabel.snp.bottom).offset(8)
      make.bottom.equalTo(contentView).inset(8)
      make.leading.equalTo(contentView).inset(16)
      make.trailing.equalTo(photoImageView.snp.leading).offset(-8)
    }
  }
  
  // MARK: - Method
  func updateUI(with data: TodoItem, image: UIImage?) {
    titleLabel.text = data.title
    dueDateLabel.text = DateFormatManager.shared.toString(with: data.dueDate, formatString: "yyyy-MM-dd HH:mm")
    memoLabel.text = data.memo.emptyToDash
    photoImageView.image = image
    priorityLabel.text = "우선순위 \(data.todoPriority.title)"
    tagLabel.text = data.tagString
  }
}
