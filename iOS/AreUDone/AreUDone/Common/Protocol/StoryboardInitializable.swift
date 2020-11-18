//
//  StoryboardInitializable.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/18.
//

import UIKit

protocol StoryboardInitializable {
  static var storyboardIndentifier: String { get }
  static var storyboardName: UIStoryboard.Storyboard { get }
  
  static func instantiateViewController() -> UIViewController
}
