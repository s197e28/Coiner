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
        
        let window = UIWindow()
        window.rootViewController = builder.make()
        window.makeKeyAndVisible()
        
        self.window = window
        return true
    }
}

