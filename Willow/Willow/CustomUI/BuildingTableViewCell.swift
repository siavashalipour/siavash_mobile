//
//  BuildingTableViewCell.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Nuke

final class BuildingTableViewCell: UITableViewCell {
  //MARK:-  UI Items
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    label.textAlignment = .left
    return label
  }()
  private lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.textColor = .black
    label.textAlignment = .left
    return label
  }()
  private lazy var buildingImageView: UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFit
    return imgView
  }()
  private lazy var tickImageView: UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFit
    imgView.isHidden = true
    imgView.image = #imageLiteral(resourceName: "icons8-checked_filled")
    return imgView
  }()
  lazy var mapButton: WCustomButton = {
    let btn = WCustomButton()
    btn.config(for: .map)
    btn.isHidden = true
    return btn
  }()
  lazy var accessoryButton1: WCustomButton = {
    let btn = WCustomButton()
    btn.isHidden = true
    return btn
  }()
  lazy var accessoryButton2: WCustomButton = {
    let btn = WCustomButton()
    btn.isHidden = true
    return btn
  }()
  
  //MARK:- private constants
  private let kButtonHeight: CGFloat = 44
  private var building: Building!
  
  // MARK:- super class method
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    mapButton.isHidden = !selected
    if building.jsonObj.availableProducts.count > 1 {
      accessoryButton1.isHidden = !selected
      accessoryButton2.isHidden = !selected
    } else {
      accessoryButton1.isHidden = !selected
    }
  }
  // MARK:- private methods
  private func setupUI() {
    _ = contentView.subviews.map({$0.removeFromSuperview})
    
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.left.top.equalTo(16)
    }
    contentView.addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { (make) in
      make.left.equalTo(titleLabel)
      make.top.equalTo(titleLabel.snp.bottom).offset(2)
    }
    contentView.addSubview(buildingImageView)
    buildingImageView.snp.makeConstraints { (make) in
      make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
      make.centerX.equalToSuperview()
      make.left.equalTo(titleLabel)
      make.height.equalTo(UIScreen.main.bounds.width - 32)
      make.bottom.equalTo(-8)
    }
    
    contentView.addSubview(mapButton)
    contentView.addSubview(accessoryButton1)
    mapButton.snp.makeConstraints { (make) in
      make.left.equalTo(titleLabel).offset(8)
      make.centerY.equalTo(buildingImageView).offset(-kButtonHeight/4)
      make.width.equalTo(accessoryButton1)
      make.height.equalTo(kButtonHeight)
    }
    accessoryButton1.snp.makeConstraints { (make) in
      make.left.equalTo(mapButton.snp.right).offset(2)
      make.width.equalTo(mapButton)
      make.centerY.equalTo(mapButton)
      make.right.equalTo(buildingImageView).offset(-8)
      make.height.equalTo(kButtonHeight)
    }
    contentView.addSubview(accessoryButton2)
    accessoryButton2.snp.makeConstraints { (make) in
      make.left.equalTo(mapButton)
      make.width.equalTo(mapButton)
      make.top.equalTo(mapButton.snp.bottom).offset(4)
      make.height.equalTo(kButtonHeight)
    }
    contentView.addSubview(tickImageView)
    tickImageView.snp.makeConstraints { (make) in
      make.centerY.equalTo(titleLabel)
      make.size.equalTo(24)
      make.right.equalTo(-8)
    }
  }
  // MARK:- pubnlic methods
  func config(with building: Building) {
    titleLabel.text = "\(building.jsonObj.address?.city ?? ""), \(building.jsonObj.address?.country ?? "")"
    subtitleLabel.text = "\(building.jsonObj.address?.line1 ?? ""), \(building.jsonObj.address?.line2 ?? "")"
    tickImageView.isHidden = !building.isRegistered
    self.building = building
    if building.jsonObj.availableProducts.count > 1 {
      accessoryButton1.config(for: building.jsonObj.availableProducts[0])
      accessoryButton2.config(for: building.jsonObj.availableProducts[1])
    } else {
      accessoryButton1.config(for: building.jsonObj.availableProducts[0])
    }
    if let url = URL(string: building.jsonObj.imageUrl) {
      let imageRequest = ImageRequest(url: url)
      Nuke.loadImage(
        with: imageRequest,
        options: ImageLoadingOptions(
          placeholder: #imageLiteral(resourceName: "placeholder"),
          transition: .fadeIn(duration: 0.33)
        ),
        into: buildingImageView
      )
    } else {
      buildingImageView.image = #imageLiteral(resourceName: "placeholder")
    }
  }
}
