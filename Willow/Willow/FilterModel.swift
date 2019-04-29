//
//  FilterModel.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation

struct Filter {
  let name: String
  var isSelected: Bool
  let type: FilterType
}

enum FilterType {
  case city
  case country
}
