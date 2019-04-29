//
//  FilterModel.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation

struct Filter: Codable {
  let name: String
  var isSelected: Bool
  let type: FilterType
}

enum FilterType: String, Codable {
  case city
  case country
}

final class FilterViewModel {
  
  private(set) var filters: [Filter]?
  
  init(with filters: [Filter]?) {
    self.filters = filters
  }
}
