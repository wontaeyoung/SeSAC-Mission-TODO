//
//  DueDateFilterViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/20/24.
//

import UIKit
import KazUtility
import SnapKit
import FSCalendar

final class DueDateFilterViewController: BaseViewController {
  
  // MARK: - UI
  private let calendar = FSCalendar()
  
  // MARK: - Property
  private var dueDateFilterUpdatingAction: ((Date) -> Void)?
  
  // MARK: - Initializer
  init(current date: Date, updating action: @escaping (Date) -> Void) {
    self.calendar.select(date, scrollToDate: true)
    self.dueDateFilterUpdatingAction = action
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    dueDateFilterUpdatingAction?(calendar.selectedDate ?? .now)
  }
  
  override func setHierarchy() {
    view.addSubview(calendar)
  }
  
  override func setConstraint() {
    calendar.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
