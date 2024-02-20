//
//  UpdatePriorityViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/15/24.
//

import UIKit
import KazUtility
import SnapKit

final class UpdatePriorityViewController: BaseViewController {
  
  // MARK: - UI
  private let prioritySegment = UISegmentedControl().configured { segment in
    TodoItem.Priority.allCases.forEach {
      segment.insertSegment(withTitle: $0.title, at: $0.index, animated: false)
    }
    
    segment.selectedSegmentIndex = 0
  }
  
  init(current priority: Int) {
    self.prioritySegment.selectedSegmentIndex = priority
    
    super.init()
  }
  
  
  // MARK: - Life Cycle
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationManager.shared.post(key: TodoNotification.NameKey.updateConfig, with: [
      TodoNotification.Info(key: .priority, value: prioritySegment.selectedSegmentIndex)
    ])
  }
  
  override func setHierarchy() {
    view.addSubview(prioritySegment)
  }
  
  override func setConstraint() {
    prioritySegment.snp.makeConstraints { make in
      make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
    }
  }
}

