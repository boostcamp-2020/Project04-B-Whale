//
//  JsonFactory.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/23.
//

import Foundation
import NetworkFramework

protocol JsonFactory {
  func loadJson(endPoint: EndPointable) -> Data?
}
