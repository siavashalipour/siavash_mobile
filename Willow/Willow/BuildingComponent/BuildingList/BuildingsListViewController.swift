//
//  ViewController.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Action

class BuildingsListViewController: UIViewController {

  private lazy var spinner: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    view.startAnimating()
    return view
  }()
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(BuildingTableViewCell.self, forCellReuseIdentifier: String(describing: BuildingTableViewCell.self))
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()
  private var navigator: Navigator!
  private var viewModel: BuildingsListViewModel!
  private let bag = DisposeBag()
  
  static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: BuildingsListViewModel) -> BuildingsListViewController {
    let vc = storyboard.instantiateViewController(ofType: BuildingsListViewController.self)
    vc.navigator = navigator
    vc.viewModel = viewModel
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    title = "Willow"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(didTapFilter))
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    view.addSubview(spinner)
    spinner.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.size.equalTo(45)
    }
    bindViewModel()
  }
  private func bindViewModel() {
    viewModel.filteredBuilding.asDriver().drive(onNext: { [weak self] _ in self?.tableView.reloadData() }).disposed(by: bag)
    viewModel.isLoading.drive(spinner.rx.isAnimating).disposed(by: bag)
    viewModel.errorObserver.subscribeOn(MainScheduler.instance).subscribe { (event) in
      if let desc = event.element {
        let alert = UIAlertController.init(title: "Oops something went wrong", message: desc, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (_) in
          
        })
        alert.addAction(action)
        self.present(alert, animated: false, completion: nil)
      }
    }
  }
  @objc
  private func didTapFilter() {
    viewModel.onFilter(input: self)
  }
  private func testResponse() {
    if let path = Bundle.main.path(forResource: "testResponse", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        if let jsonResult = jsonResult as? Array<Dictionary<String, AnyObject>> {
          // do stuff
          var buildings: [BuildingJSON] = []
          for item in jsonResult {
            let decoder = JSONDecoder()
            let data2 = try JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
            let building = try decoder.decode(BuildingJSON.self, from: data2)
            buildings.append(building)
          }
          print(buildings)
        } else {
          print("SADFASDF")
        }
      } catch let error {
        // handle error
        print(error)
      }
    }
  }
}

extension BuildingsListViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.filteredBuilding.value?.count ?? 0
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(ofType: BuildingTableViewCell.self)
    if let item = viewModel.filteredBuilding.value?[indexPath.row] {
      cell.config(with: item)
      cell.mapButton.rx.action = viewModel.onCellButtonAction(indexPath: indexPath, input: cell.mapButton, on: self)
      cell.accessoryButton1.rx.action = viewModel.onCellButtonAction(indexPath: indexPath, input: cell.accessoryButton1, on: self)
      cell.accessoryButton2.rx.action = viewModel.onCellButtonAction(indexPath: indexPath, input: cell.accessoryButton2, on: self)
    }
    return cell
  }
}
