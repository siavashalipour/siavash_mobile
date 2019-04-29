//
//  BuildingModel.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation

struct Building {
  let id: Int
  let name: String
  let clinetId: Int
  let clinetName: String
  let address: Address
  let productTypes: [ProductType]
}

struct Address {
  let id: String
  let line1: String
  let line2: String?
  let city: String
  let state: String
  let zipCode: Int
  let country: String
  let lon: Double
  let lat: Double
}
enum ProductType: String {
  case explorer = "AssetExplorer"
  case register = "AssetRegister"
  
  var previewDescription: String {
    switch self {
    case .explorer:
      return "Go to explorer"
    case .register:
      return "Register"
    }
  }
}
