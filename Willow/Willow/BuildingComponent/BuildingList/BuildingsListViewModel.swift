//
//  BuildingsListViewModel.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import RxSwift
import RxCocoa
import Action
import MapKit

final class BuildingsListViewModel {
  
  let filteredBuilding = Variable<[Building]?>(nil)
  lazy var isLoading: Driver<Bool> = {
    return isLoadingPublisher.asDriver(onErrorJustReturn: true)
  }()
  lazy var errorObserver: Observable<String> = {
    return errorPublisher.asObservable()
  }()
  private var isLoadingPublisher = PublishSubject<Bool>()
  private var errorPublisher = PublishSubject<String>()
  
  private(set) var filters: [Filter]?
  private let buildings = Variable<[Building]?>(nil)
  private let bag = DisposeBag()
  private let navigator: Navigator
  
  init(with filter: [Filter]?, navigator: Navigator) {
    self.filters = filter
    self.navigator = navigator
    self.isLoadingPublisher.onNext(true)
    fetch()
  }
  
  func fetch() {
    BuildingServices.shared.fetch().subscribe(onNext: { (result) in
      switch result {
      case .success(let jsonData):
        var buildings: [Building] = []
        for item in jsonData {
          let decoder = JSONDecoder()
          do {
            let data2 = try JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
            let buildingJson = try decoder.decode(BuildingJSON.self, from: data2)
            let building = Building(jsonObj: buildingJson, isRegistered: false)
            buildings.append(building)
          } catch let error {
            self.errorPublisher.onNext(error.localizedDescription)
          }
          DispatchQueue.main.async {
            self.buildings.value = buildings
            self.filteredBuilding.value = buildings
            self.fillupFilter(for: buildings)
            self.isLoadingPublisher.onNext(false)
          }
        }
      case .error(let error):
        self.errorPublisher.onNext(error.localizedDescription)
      }
    }).disposed(by: bag)
  }
  private func fillupFilter(for buildings: [Building]) {
    var countries: Set<String> = []
    var cities: Set<String> = []
    
    _  = buildings.map {
      if let country = $0.jsonObj.address?.country {
        countries.insert(country)
      }
      if let city = $0.jsonObj.address?.city {
        cities.insert(city)
      }
    }
    var filters: [Filter] = []
    _ = countries.map {
      let filter = Filter(name: $0, isSelected: false, type: .country)
      filters.append(filter)
    }
    _ = cities.map {
      let filter = Filter(name: $0, isSelected: false, type: .city)
      filters.append(filter)
    }
    self.filters = filters
  }
  func updateFilter(to filters: [Filter]?) {
    self.filters = filters
  }
  func onFilter(input: UIViewController) {
    if let filters = self.filters {
      let vm = FilterViewModel(with: filters)
      self.navigator.show(segue: .filter(vm), sender: input)
      vm.filters.asObservable().subscribe(onNext: { (filters) in
        var result: Set<Building>? = []
        for filter in filters {
          if filter.isSelected {
            switch filter.type {
            case .city:
              _ = self.buildings.value?.filter {$0.jsonObj.address?.city == filter.name}.map {
                result?.insert($0)
              }
            case .country:
              _ = (self.buildings.value?.filter {$0.jsonObj.address?.country == filter.name} ?? []).map {
                result?.insert($0)
              }
            }
          }
        }
        if let safeResult = result, safeResult.count > 0 {
          self.filteredBuilding.value = Array(safeResult)
        } else {
          self.filteredBuilding.value = self.buildings.value
        }
      })
      .disposed(by: bag)
    }
  }
  func onCellButtonAction(indexPath: IndexPath, input: WCustomButton, on: UIViewController) -> CocoaAction {
    return CocoaAction {
      switch input.type {
      case .explorer:
        if let item = self.filteredBuilding.value?[indexPath.row] {
          self.navigator.show(segue: .buildingsViewController(item), sender: on)
        }
      case .register:
        self.registerBuilding(at: indexPath)
      case .map:
        if let item = self.filteredBuilding.value?[indexPath.row].jsonObj {
          guard let latitude = item.address?.latitude, let longitude = item.address?.longitude else {
            let alert = UIAlertController.init(title: "Invalid Latitude and/or Longitude", message: nil, preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) in
              
            })
            alert.addAction(action)
            on.present(alert, animated: false, completion: nil)
            break
          }
          let regionDistance:CLLocationDistance = 10000
          let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
          let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
          let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
          ]
          let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
          let mapItem = MKMapItem(placemark: placemark)
          mapItem.name = "\(item.name ?? "Place mark")"
          mapItem.openInMaps(launchOptions: options)
        }
      }
      
      return .empty()
    }
  }
  func registerBuilding(at indexPath: IndexPath) {
    if var item = filteredBuilding.value?[indexPath.row] {
      item.isRegistered = true
      filteredBuilding.value?[indexPath.row] = item
      buildings.value?[indexPath.row] = item
    }
  }
}
