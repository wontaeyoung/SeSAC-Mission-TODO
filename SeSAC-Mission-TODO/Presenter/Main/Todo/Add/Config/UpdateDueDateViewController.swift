//
//  UpdateDueDateViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/15/24.
//

import UIKit
import KazUtility

final class UpdateDueDateViewController: BaseViewController {
  
  // MARK: - UI
  private let datePicker = UIDatePicker().configured {
    $0.datePickerMode = .date
    $0.preferredDatePickerStyle = .automatic
  }
  
  // MARK: - Property
  var updateDueDateAction: (Date) -> Void
  
  // MARK: - Initializer
  init(current: Date, updateDateAction: @escaping (Date) -> Void) {
    self.datePicker.setDate(current, animated: true)
    self.updateDueDateAction = updateDateAction
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    updateDueDateAction(datePicker.date)
  }
  
  override func setHierarchy() {
    view.addSubview(datePicker)
  }
  
  override func setConstraint() {
    datePicker.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
