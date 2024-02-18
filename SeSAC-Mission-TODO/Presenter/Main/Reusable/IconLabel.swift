//
//  IconLabel.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/16/24.
//

import UIKit
import KazUtility

final class IconLabel: BaseView {
  
  private let imageView = UIImageView()
  private let label = UILabel()
  
  init(symbol: String?, text: String?) {
    self.imageView.image = UIImage(systemName: symbol ?? "")
    self.label.text = text
    
    super.init(frame: .zero)
  }
  
  override func setHierarchy() {
    self.addSubview(imageView)
    self.addSubview(label)
  }
  
  override func setAttribute() {
    imageView.contentMode = .scaleAspectFit
    label.font = .systemFont(ofSize: 17, weight: .bold)
  }
  
  override func setConstraint() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    label.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: self.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 33),
      imageView.heightAnchor.constraint(equalToConstant: 33)
    ])
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: self.topAnchor),
      label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
      label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
  
  public func updateUI(symbol: String, text: String) {
    self.imageView.image = UIImage(systemName: symbol)
    self.label.text = text
  }
}

