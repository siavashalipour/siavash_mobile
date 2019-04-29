//
//  FilterModel.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation
import RxSwift

class Filter: Codable {
  let name: String
  var isSelected: Bool
  let type: FilterType
  
  init(name: String, isSelected: Bool, type: FilterType) {
    self.name = name
    self.isSelected = isSelected
    self.type = type
  }
}

enum FilterType: Int, Codable {
  case country
  case city

  var description: String {
    switch self {
    case .city:
      return "CITY"
    case .country:
      return "COUNTRY"
      
    }
  }
}

final class FilterViewModel {
  
  private(set) var filters: Variable<[Filter]> = Variable([])
  
  init(with filters: [Filter]) {
    self.filters.value = filters
  }
  func numberOfRows(for section: Int) -> Int {
    if section == 0 {
      return filters.value.filter { $0.type == .country }.count
    } else {
      return filters.value.filter { $0.type == .city }.count
    }
  }
  func headerItem(at section: Int) -> FilterType {
    if section == 0 {
      return (.country)
    } else {
      return (.city)
    }
  }
  func clearAll(for filterType: FilterType) {
    for index in 0..<filters.value.count {
      let item = filters.value[index]
      if item.type == filterType {
        item.isSelected = false
        filters.value[index] = item
      }
    }
  }
  func item(at indexPath: IndexPath) -> Filter {
    if indexPath.section == 0 {
      return filters.value.filter { $0.type == .country}[indexPath.row]
    } else {
      return filters.value.filter { $0.type == .city}[indexPath.row]
    }
  }
  func didSelectRow(at indexPath: IndexPath) {
    let item: Filter
    if indexPath.section == 0 {
      item = filters.value.filter {$0.type == .country}[indexPath.row]
      
    } else {
      item = filters.value.filter {$0.type == .city}[indexPath.row]
    }
    if let index = filters.value.firstIndex(where: { (filter) -> Bool in
      filter.name == item.name
    }) {
      item.isSelected = !item.isSelected
      filters.value[index] = item
    }
  }
}
