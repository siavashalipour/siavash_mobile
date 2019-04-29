//
//  BuildingServices.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import RxSwift


enum ApiError: Error {
  case badReponse
  case unexpectedFormat
}
public enum MFResult<T, E> {
  case success(T)
  case error(E)
}

public extension MFResult {
  var object: T? {
    switch self {
    case .success(let value):
      return value
    default:
      return nil
    }
  }
  var error: E? {
    switch self {
    case .error(let err):
      return err
    default:
      return nil
    }
  }
}
final class BuildingServices {
  
  static var shared = BuildingServices()
  let baseURL = URL.init(string: "https://gist.githubusercontent.com/Lachlanbsmith/c5eb3b858ff810febd3dfbd5960d3fd8/raw/64a0ba3ee02d52536157d2dd01dddb1069175a8f")!
  
  func fetch() -> Observable<MFResult<Array<Dictionary<String, AnyObject>>,ApiError>> {
    
    return buildRequest(path: "buildings", jsonData: nil).timeout(5, scheduler: MainScheduler.instance).map() { data in
      do {
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        if let jsonResult = jsonResult as? Array<Dictionary<String, AnyObject>> {
          return MFResult.success(jsonResult)
        } else {
          return MFResult.error(ApiError.unexpectedFormat)
        }
      }
      catch {
        return MFResult.error(ApiError.badReponse)
      }
    }
  }
  
  private func buildRequest(method: String = "GET", path: String, jsonData: Data?) -> Observable<Data> {
    
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest.init(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    request.httpMethod = method
    
    let session = URLSession.shared
    
    return session.rx.data(request: request)
  }
}
