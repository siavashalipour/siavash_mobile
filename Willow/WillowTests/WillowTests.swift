//
//  WillowTests.swift
//  WillowTests
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import XCTest
@testable import Willow

class WillowTests: XCTestCase {
  
  var buildings: [Building] = []
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    super.setUp()
    try? testResponse()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testJsonMapping() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssert(buildings.count > 0)
  }
  func testOnRegister() {
    let viewModel = BuildingsListViewModel.init(with: nil, navigator: Navigator.init(), buildings: self.buildings)
    let indexPath = IndexPath(item: 0, section: 1)
    viewModel.registerBuilding(at: indexPath)
    XCTAssert(viewModel.filteredBuilding.value![indexPath.row].isRegistered)
  }
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  private func testResponse() throws {
    if let path = Bundle.main.path(forResource: "testResponse", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        if let jsonResult = jsonResult as? Array<Dictionary<String, AnyObject>> {
          // do stuff
          for item in jsonResult {
            let decoder = JSONDecoder()
            let data2 = try JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
            let buildingJson = try decoder.decode(BuildingJSON.self, from: data2)
            let building = Building(jsonObj: buildingJson, isRegistered: false)
            buildings.append(building)
          }
        } else {
          throw(ApiError.badReponse)
        }
      } catch let error {
        // handle error
        throw(error)
      }
    }
  }
}
