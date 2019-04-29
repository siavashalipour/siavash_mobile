//
//  BuildingsListViewModel.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import RxSwift
import RxCocoa

final class BuildingsListViewModel {
  private(set) var filters: [Filter]?
  
  let buildings = Variable<[Building]?>(nil)
  private let bag = DisposeBag()
  
  init(with filter: [Filter]?) {
    self.filters = filter
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
            let building = try decoder.decode(Building.self, from: data2)
            buildings.append(building)
          } catch {
            
          }
          DispatchQueue.main.async {
            self.buildings.value = buildings
            self.fillupFilter(for: buildings)
          }
        }
      case .error(_):
        break
      }
    }).disposed(by: bag)
  }
  private func fillupFilter(for buildings: [Building]) {
    var countries: Set<String> = []
    var cities: Set<String> = []
    
    _  = buildings.map {
      if let country = $0.address?.country {
        countries.insert(country)
      }
      if let city = $0.address?.city {
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
}
