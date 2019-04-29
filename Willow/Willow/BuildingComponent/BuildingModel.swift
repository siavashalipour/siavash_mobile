//
//  BuildingModel.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation

typealias Codable = Decodable & Encodable

struct Building: Codable {
  let id: Int
  let name: String?
  let clinetId: Int?
  let clinetName: String?
  let address: Address?
  let availableProducts: [ProductType]
  let imageUrl: String
}

struct Address: Codable {
  let id: String
  let line1: String?
  let line2: String?
  let city: String?
  let state: String?
  let zipCode: String?
  let country: String?
  let lon: Double?
  let lat: Double?
}
enum ProductType: String, Codable {
  case explorer = "AssetExplorer"
  case register = "AssetRegister"
  case map
  
  var previewDescription: String {
    switch self {
    case .explorer:
      return "Go to Explorer"
    case .register:
      return "Register"
    case .map:
      return "View on Map"
    }
  }
}
