//
//  BuildingModel.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation

typealias Codable = Decodable & Encodable

struct Building: Hashable {

  
  let jsonObj: BuildingJSON
  var isRegistered: Bool = false
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(jsonObj.id)
  }
  static func == (lhs: Building, rhs: Building) -> Bool {
    return lhs.jsonObj.id == rhs.jsonObj.id
  }
  func description() -> String {
    return """
    id = "\(jsonObj.id)"
    name = "\(jsonObj.name ?? "")"
    address = "\(jsonObj.address?.line1 ?? ""), \(jsonObj.address?.city ?? ""), \(jsonObj.address?.country ?? ""), \(jsonObj.address?.zipCode ?? "")"
    """
  }
}
struct BuildingJSON: Codable {
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
  let longitude: Double?
  let latitude: Double?
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
