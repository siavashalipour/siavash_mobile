//
//  FilterTableViewCell.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation
import SnapKit

final class FilterTableViewCell: UITableViewCell {
  
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    label.textAlignment = .left
    return label
  }()
  private lazy var tickImageView: UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFit
    imgView.image = #imageLiteral(resourceName: "icons8-checkmark_filled")
    imgView.isHidden = true
    return imgView
  }()
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupUI()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  private func setupUI() {
    _ = contentView.subviews.map({$0.removeFromSuperview})
    
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.left.top.equalTo(8)
      make.centerY.equalToSuperview()
    }
    contentView.addSubview(tickImageView)
    tickImageView.snp.makeConstraints { (make) in
      make.size.equalTo(15)
      make.right.equalTo(-8)
      make.centerY.equalToSuperview()
    }
  }
  func config(with filter: Filter) {
    tickImageView.isHidden = !filter.isSelected
    titleLabel.text = filter.name
  }
}
