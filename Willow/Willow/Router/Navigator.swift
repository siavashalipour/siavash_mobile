//
//  Navigator.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Navigator {
  lazy private var defaultStoryboard = UIStoryboard(name: "Main", bundle: nil)
  
  // MARK: - segues list
  enum Segue {
    case buildingsListViewController(BuildingsListViewModel)
    case filter(FilterViewModel)
    case buildingsViewController(Building)
  }
  
  // MARK: - invoke a single segue
  func show(segue: Segue, sender: UIViewController) {
    switch segue {
    case .buildingsListViewController(let viewModel):
      show(target: BuildingsListViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, viewModel: viewModel), sender: sender)
    case .filter(let viewModel):
      show(target: FilterViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, viewModel: viewModel), sender: sender)
    case .buildingsViewController(let model):
      show(target: BuildingsViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, model: model), sender: sender)
    }
  }
  
  private func show(target: UIViewController, sender: UIViewController) {
    if let nav = sender as? UINavigationController {
      //push root controller on navigation stack
      nav.pushViewController(target, animated: false)
      return
    }
    
    if let nav = sender.navigationController {
      //add controller to navigation stack
      nav.pushViewController(target, animated: true)
    } else {
      //present modally
      sender.present(target, animated: true, completion: nil)
    }
  }
}


