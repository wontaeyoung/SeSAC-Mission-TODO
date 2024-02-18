//
//  UpdateFlagViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/18/24.
//

import UIKit
import KazUtility
import SnapKit

final class UpdateFlagViewController: BaseViewController {
  
  // MARK: - UI
  private let flagLabel = IconLabel(symbol: nil, text: nil)
  private lazy var toggleSwitch = UISwitch().configured {
    $0.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
    $0.onTintColor = .accent
  }
  
  // MARK: - Initializer
  init(current isOn: Bool) {
    super.init()
    
    toggleSwitch.setOn(isOn, animated: false)
    updateUI()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(flagLabel, toggleSwitch)
  }
  
  override func setConstraint() {
    flagLabel.snp.makeConstraints { make in
      make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.centerY.equalTo(toggleSwitch)
    }
    
    toggleSwitch.snp.makeConstraints { make in
      make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.leading.equalTo(flagLabel.snp.trailing).offset(16)
    }
  }
  
  // MARK: - Method
  private func updateUI() {
    let flagSymbol: String = toggleSwitch.isOn ? "flag.fill" : "flag"
    flagLabel.updateUI(symbol: flagSymbol, text: "깃발")
  }
  
  // MARK: - Selector
  @objc private func switchToggled() {
    updateUI()
  }
}

