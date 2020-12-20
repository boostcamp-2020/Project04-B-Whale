//
//  SettingViewModel.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/15.
//

import Foundation

protocol SettingViewModelProtocol {
  
  func bindingLogoutHandler(handler: @escaping (() -> Void))
  
  func logout()
}

final class SettingViewModel: SettingViewModelProtocol {
  
  // MARK: - Property
  
  private var logoutHandler: (() -> Void)?
  
  
  // MARK: - Method
  
  func logout() {
    logoutHandler?()
  }
}


// MARK: - Extension BindUI

extension SettingViewModel {
  
  func bindingLogoutHandler(handler: @escaping (() -> Void)) {
    logoutHandler = handler
  }
}
