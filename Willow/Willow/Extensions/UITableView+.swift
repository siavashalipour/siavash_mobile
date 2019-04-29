//
//  UITableView+.swift
//  Willow
//
//  Created by Siavash on 29/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import UIKit

extension UITableView {
  func dequeueCell<T>(ofType type: T.Type) -> T {
    return dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
  }
}
