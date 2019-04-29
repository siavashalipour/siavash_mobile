//
//  BuildingViewController.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift
import Nuke

final class BuildingsViewController: UIViewController {
  
  private var navigator: Navigator!
  private var model: Building!
  private let bag = DisposeBag()
  
  private lazy var objectLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  private lazy var imageView: UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFit
    return imgView
  }()
  
  static func createWith(navigator: Navigator, storyboard: UIStoryboard, model: Building) -> BuildingsViewController {
    let vc = storyboard.instantiateViewController(ofType: BuildingsViewController.self)
    vc.navigator = navigator
    vc.model = model
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = model.jsonObj.name
    view.addSubview(objectLabel)
    objectLabel.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
      make.left.equalTo(8)
      make.centerX.equalToSuperview()
    }
    view.addSubview(imageView)
    imageView.snp.makeConstraints { (make) in
      make.top.equalTo(objectLabel.snp.bottom)
      make.left.equalTo(objectLabel)
      make.centerX.equalToSuperview()
      make.width.equalTo(UIScreen.main.bounds.width - 16)
    }
    objectLabel.text = model.description()
    if let url = URL(string: model.jsonObj.imageUrl) {
      Nuke.loadImage(with: url, into: imageView)
    }
  }
}
