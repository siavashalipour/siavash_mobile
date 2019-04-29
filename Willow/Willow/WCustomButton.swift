//
//  WCustomButton.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation
import UIKit

final class WCustomButton: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func setupUI() {
    layer.cornerRadius = 8
    layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    layer.borderWidth = 1
    setTitleColor(.white, for: .normal)
  }
  func config(for type: ProductType) {
    setTitle(type.previewDescription, for: .normal)
    switch type {
    case .explorer:
      setImage(#imageLiteral(resourceName: "icons8-arrow_filled"), for: .normal)
    case .register:
      setImage(#imageLiteral(resourceName: "icons8-logout_rounded_up_filled"), for: .normal)
    case .map:
      setImage(#imageLiteral(resourceName: "icons8-marker"), for: .normal)
    }
  }
}
