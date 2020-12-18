//
//  Path.swift
//  NetworkFramework
//
//  Created by a1111 on 2020/12/15.
//

import Foundation

public enum Path {
    public static let cached = FileManager.default.urls(
      for: .cachesDirectory,
        in: .userDomainMask
    ).first
}
