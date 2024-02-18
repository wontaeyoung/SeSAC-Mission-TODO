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
    $0.preferredDatePickerStyle = .inline
    $0.locale = .kr
  }
  
  private lazy var todayButton = UIButton().configured { button in
    button.configuration = .filled().configured {
      $0.title = "오늘로 설정"
      $0.cornerStyle = .medium
      $0.buttonSize = .medium
    }
    
    button.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)
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
    view.addSubviews(datePicker, todayButton)
  }
  
  override func setConstraint() {
    datePicker.snp.makeConstraints { make in
      make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
    }
    
    todayButton.snp.makeConstraints { make in
      make.top.equalTo(datePicker.snp.bottom).offset(8)
      make.trailing.equalTo(view).inset(16)
    }
  }
  
  // MARK: - Selector
  @objc private func todayButtonTapped() {
    datePicker.setDate(.now, animated: true)
  }
}
