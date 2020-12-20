//
//  SigninChecker.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/20.
//

import Foundation

enum SigninCheckResult {
  case isSigned
  case isNotSigned
}

protocol SigninCheckable {
  
  func check() -> SigninCheckResult
}

final class SigninChecker: SigninCheckable {
  
  // MARK:- Method
  
  func check() -> SigninCheckResult {
    if let _ = Keychain.shared.loadValue(forKey: KeyChainConstant.token) {
      return .isSigned
    }
    return .isNotSigned
  }
}
