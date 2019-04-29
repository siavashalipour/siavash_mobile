//
//  FilterViewController.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift

final class FilterViewController: UIViewController {
  
  
  private var navigator: Navigator!
  private var viewModel: FilterViewModel!
  private let bag = DisposeBag()
  
  static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: FilterViewModel) -> FilterViewController {
    let vc = storyboard.instantiateViewController(ofType: FilterViewController.self)
    vc.navigator = navigator
    vc.viewModel = viewModel
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
