//
//  SceneDelegate.swift
//  AnimaAi
//
//  Created by user on 13/07/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?



    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
   
        guard let windowScene = (scene as? UIWindowScene) else { return }
       window = UIWindow(windowScene: windowScene)
        
  
        let storyBoard = UIStoryboard(name: "SplashScreen", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "SplashViewController")
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            
            let layout = UICollectionViewFlowLayout()
            
            let navigationController = UINavigationController(rootViewController: AnimeViewController(collectionViewLayout: layout))

            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
      
    }

}
