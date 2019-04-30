//
//  AppController.swift
//  ObjectDetection
//
//  Created by Skafos.ai on 1/7/19.
//  Copyright © 2019 Skafos, LLC. All rights reserved.
//

import Foundation
import UIKit

class AppController : NSObject {
  fileprivate static let instance = AppController()

  let window:UIWindow

  private var launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil

  override init() {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window.rootViewController = VisionObjectRecognitionViewController()

    super.init()
  }

  func dispatch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    self.launchOptions = launchOptions
    
    self.window.makeKeyAndVisible()

    return true
  }
}

let app = AppController.instance
