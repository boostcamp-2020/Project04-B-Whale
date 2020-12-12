//
//  SecureStoreError.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/12.
//

import Foundation

public enum SecureStoreError: Error {
  
  case stringToDataConversionError
  case dataToStringConversionError
  case unhandledError(message: String)
}

extension SecureStoreError: LocalizedError {
  
  public var errorDescription: String? {
    switch self {
    case .stringToDataConversionError:
      return NSLocalizedString("String to Data conversion error", comment: "")
    case .dataToStringConversionError:
      return NSLocalizedString("Data to String conversion error", comment: "")
    case .unhandledError(let message):
      return NSLocalizedString(message, comment: "")
    }
  }
}
