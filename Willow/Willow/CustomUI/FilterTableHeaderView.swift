//
//  FilterTableHeaderView.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation
import SnapKit

final class FilterTableHeaderView: UITableViewHeaderFooterView {
  
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    label.textAlignment = .left
    return label
  }()
  private lazy var clearLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textColor = #colorLiteral(red: 0.2196078431, green: 0.4352941176, blue: 0.5568627451, alpha: 1)
    label.textAlignment = .left
    label.text = "Clear"
    return label
  }()
  lazy var btn: UIButton = {
    let btn = UIButton()
    return btn
  }()
  private(set) var type: FilterType!
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func setupUI() {
    _ = subviews.map({$0.removeFromSuperview()})
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalTo(8)
      make.centerY.equalToSuperview()
    }
    
    addSubview(clearLabel)
    clearLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(titleLabel)
      make.right.equalTo(-8)
    }
    
    addSubview(btn)
    btn.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  func config(with type: FilterType) {
    titleLabel.text = type.description
    self.type = type
  }
}
