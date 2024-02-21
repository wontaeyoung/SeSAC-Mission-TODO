//
//  MakeBoxViewController.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/20/24.
//

import UIKit
import KazUtility
import SnapKit

enum MakeBoxStyle {
  case add
  case update(box: TodoBox)
  
  var title: String {
    switch self {
      case .add:
        return "새로운 박스"
      case .update:
        return "박스 수정하기"
    }
  }
}

final class MakeBoxViewController: BaseViewController {
  
  // MARK: - UI
  private let titleCardView = CardView()
  
  private lazy var boxIconButton = UIButton().configured { button in
    button.configuration = .filled().configured {
      $0.buttonSize = .large
      $0.cornerStyle = .capsule
      $0.baseForegroundColor = .white
      $0.image = iconImage
      $0.baseBackgroundColor = iconColor
    }
  }
  
  private lazy var titleField = UITextField().configured {
    $0.placeholder = "목록 이름"
    $0.textAlignment = .center
    $0.borderStyle = .roundedRect
    $0.backgroundColor = .systemGray5
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
    $0.addTarget(self, action: #selector(titleFieldDidChanged), for: .editingChanged)
  }
  
  private let colorPaletteCardView = CardView()
  
  private lazy var colorStack = UIStackView().configured { stack in
    stack.axis = .horizontal
    stack.spacing = 16
    stack.alignment = .fill
    stack.distribution = .fillEqually
    
    BoxIcon.BoxColor.allCases.enumerated().forEach { index, color in
      
      let colorButton = UIButton().configured {
        $0.tag = index
        $0.addTarget(self, action: #selector(colorTapped), for: .touchUpInside)
        $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
        $0.configuration = .filled().configured {
          $0.baseBackgroundColor = .init(hex: color.code)
          $0.buttonSize = .medium
          $0.cornerStyle = .capsule
        }
      }
      
      stack.addArrangedSubview(colorButton)
    }
  }
  
  private let symbolPaletteCardView = CardView()
  
  private lazy var symbolStack = UIStackView().configured { stack in
    stack.axis = .horizontal
    stack.spacing = 16
    stack.alignment = .fill
    stack.distribution = .fillEqually
    
    BoxIcon.BoxSymbol.allCases.enumerated().forEach { index, symbol in
      
      let symbolButton = UIButton().configured {
        $0.tag = index
        $0.addTarget(self, action: #selector(symbolTapped), for: .touchUpInside)
        $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
        $0.configuration = .filled().configured {
          $0.image = UIImage(systemName: symbol.symbol)
          $0.baseBackgroundColor = .systemGray3
          $0.buttonSize = .medium
          $0.cornerStyle = .capsule
        }
      }
      
      stack.addArrangedSubview(symbolButton)
    }
  }
  
  // MARK: - Property
  private let makeBoxStyle: MakeBoxStyle
  
  private var boxColor: BoxIcon.BoxColor {
    didSet {
      boxIconButton.configuration?.baseBackgroundColor = iconColor
    }
  }
  private var boxSymbol: BoxIcon.BoxSymbol {
    didSet {
      boxIconButton.configuration?.image = iconImage
    }
  }
  
  private var selectedColorIndex: Int {
    didSet {
      boxColor = .allCases[selectedColorIndex]
    }
  }
  
  private var selectedSymbolIndex: Int {
    didSet {
      boxSymbol = .allCases[selectedSymbolIndex]
    }
  }
  
  private var iconColor: UIColor {
    return UIColor(hex: boxColor.code)
  }
  
  private var iconImage: UIImage? {
    return UIImage(systemName: boxSymbol.symbol)
  }
  
  private var colorItems: [UIView] {
    return colorStack.arrangedSubviews
  }
  
  private var symbolItems: [UIView] {
    return symbolStack.arrangedSubviews
  }
  
  private var titleText: String {
    return titleField.text ?? ""
  }
  
  // MARK: - Initializer
  init(makeBoxStyle: MakeBoxStyle, makeBoxAction: @escaping (TodoBox) -> Void) {
    var title: String?
    self.makeBoxStyle = makeBoxStyle
    
    switch makeBoxStyle {
      case .add:
        self.boxColor = .first
        self.boxSymbol = .first
        
      case .update(let box):
        let icon = box.icon ?? .default
        
        self.boxColor = icon.boxColor
        self.boxSymbol = icon.boxSymbol
        title = box.name
    }
    
    self.selectedColorIndex = boxColor.index
    self.selectedSymbolIndex = boxSymbol.index
    
    super.init()
    
    self.titleField.text = title
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(titleCardView, colorPaletteCardView, symbolPaletteCardView)
    titleCardView.addSubviews(boxIconButton, titleField)
    colorPaletteCardView.addSubviews(colorStack)
    symbolPaletteCardView.addSubviews(symbolStack)
  }
  
  override func setAttribute() {
    setBarItem()
    updateDoneButtonEnabled(isEmpty: titleText.isEmpty)
    
    GCD.main { [weak self] in
      guard let self else { return }
      
      selectColor(tag: selectedColorIndex)
      selectSymbol(tag: selectedSymbolIndex)
    }
  }
  
  override func setConstraint() {
    titleCardView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.horizontalEdges.equalTo(view).inset(16)
    }
    
    boxIconButton.snp.makeConstraints { make in
      make.top.equalTo(titleCardView).inset(16)
      make.centerX.equalTo(titleCardView)
    }
    
    titleField.snp.makeConstraints { make in
      make.top.equalTo(boxIconButton.snp.bottom).offset(16)
      make.horizontalEdges.equalTo(titleCardView).inset(16)
      make.bottom.equalTo(titleCardView).inset(16)
      make.height.equalTo(50)
    }
    
    colorPaletteCardView.snp.makeConstraints { make in
      make.top.equalTo(titleCardView.snp.bottom).offset(16)
      make.horizontalEdges.equalTo(view).inset(16)
    }
    
    colorStack.snp.makeConstraints { make in
      make.edges.equalTo(colorPaletteCardView).inset(16)
    }
    
    symbolPaletteCardView.snp.makeConstraints { make in
      make.top.equalTo(colorPaletteCardView.snp.bottom).offset(16)
      make.horizontalEdges.equalTo(view).inset(16)
    }
    
    symbolStack.snp.makeConstraints { make in
      make.edges.equalTo(symbolPaletteCardView).inset(16)
    }
  }
  
  // MARK: - Method
  private func setBarItem() {
    let done = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneTapped))
    
    navigationItem.rightBarButtonItem = done
  }
  
  private func deselectAllColor() {
    colorItems.forEach {
      $0.layer.borderWidth = 0
    }
  }
  
  private func deselectAllSymbol() {
    symbolItems.forEach {
      $0.layer.borderWidth = 0
    }
  }
  
  private func selectColor(tag: Int) {
    selectedColorIndex = tag
    
    colorItems[selectedColorIndex].configure {
      $0.layer.cornerRadius = $0.bounds.width / 2
      $0.layer.borderWidth = 2
      $0.layer.borderColor = UIColor.white.cgColor
    }
  }
  
  private func selectSymbol(tag: Int) {
    selectedSymbolIndex = tag
    
    symbolItems[selectedSymbolIndex].configure {
      $0.layer.cornerRadius = $0.bounds.width / 2
      $0.layer.borderWidth = 2
      $0.layer.borderColor = UIColor.white.cgColor
    }
  }
  
  private func createNewTodoBox() -> TodoBox {
    let boxIcon = BoxIcon(color: boxColor.code, symbol: boxSymbol.symbol)
    
    return TodoBox(name: titleText, icon: boxIcon)
  }
  
  private func updateDoneButtonEnabled(isEmpty: Bool) {
    navigationItem.rightBarButtonItem?.isEnabled = !isEmpty
  }
  
  // MARK: - Selector
  @objc private func doneTapped() {
    let todoBox = createNewTodoBox()
    
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func titleFieldDidChanged() {
    updateDoneButtonEnabled(isEmpty: titleText.isEmpty)
  }
  
  @objc private func colorTapped(_ sender: UIButton) {
    deselectAllColor()
    selectColor(tag: sender.tag)
  }
  
  @objc private func symbolTapped(_ sender: UIButton) {
    deselectAllSymbol()
    selectSymbol(tag: sender.tag)
  }
}
