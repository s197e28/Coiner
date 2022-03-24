//
//  AppDelegate.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/23/22.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var resolver: Resolver {
        Configurator.sharedInstance.resolver
    }
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let builder = resolver.resolve(MainBuilderProtocol.self) else {
            return false
        }
        
        setupAppearance()
        
        let window = UIWindow()
        window.rootViewController = builder.make()
        window.makeKeyAndVisible()
        
        self.window = window
        return true
    }
    
    private func setupAppearance() {
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

