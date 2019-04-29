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
import RxGesture
import Action

final class FilterViewController: UIViewController {
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: String(describing: FilterTableViewCell.self))
    tableView.register(FilterTableHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: FilterTableHeaderView.self))
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()
  
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
    title = "Filter"
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    bindViewModel()
  }
  private func bindViewModel() {
    viewModel.filters.asDriver().drive(onNext: { [weak self] _ in self?.tableView.reloadData() }).disposed(by: bag)
  }

}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows(for: section)
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(ofType: FilterTableViewCell.self)
    cell.config(with: viewModel.item(at: indexPath))
    return cell
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = FilterTableHeaderView()
    let type = viewModel.headerItem(at: section)
    view.config(with: type)
    view.btn.rx.action = CocoaAction { [weak self] in
      self?.viewModel.clearAll(for: type)
      return .empty()
    }
    return view
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 44
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     viewModel.didSelectRow(at: indexPath)
  }
}
