//
//  SceneDelegate.swift
//  SeSAC-Mission-TODO
//
//  Created by 원태영 on 2/14/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var coordinator: AppCoordinator?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    let rootController = UINavigationController()
    coordinator = AppCoordinator(rootController)
    
    window = UIWindow(windowScene: scene)
    window?.rootViewController = rootController
    window?.makeKeyAndVisible()
    
    coordinator?.start()
  }
}
