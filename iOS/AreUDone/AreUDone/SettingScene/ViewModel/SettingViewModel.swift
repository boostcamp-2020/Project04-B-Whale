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
  
  private var logoutHandler: (() -> Void)?
  
  func logout() {
    logoutHandler?()
  }
}


extension SettingViewModel {
  
  func bindingLogoutHandler(handler: @escaping (() -> Void)) {
    logoutHandler = handler
  }
}
