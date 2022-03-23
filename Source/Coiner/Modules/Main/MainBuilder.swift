//
//  MainBuilder.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/23/22.
//

import UIKit
import Swinject

final class MainBuilder: MainBuilderProtocol {
    
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
//    convenience init(resolver: Resolver) {
//        self.init(
//            resolver: resolver)
//    }
    
    func make() -> UIViewController {
        let viewController = MainViewController()
        let presenter = MainPresenter(view: viewController)
        
        viewController.presenter = presenter
        
        viewController.navigationController?.navigationBar.isHidden = true
        viewController.viewControllers = [makeAssetsModule(), makeWatchlistModule(), makeSettingsModule()]
        viewController.selectedIndex = 0
        
        return viewController
    }
    
    private func makeAssetsModule() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .red
        
        let item = UITabBarItem()
        item.title = "Assets"
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.viewControllers = [viewController]
        navigationController.tabBarItem = item
        
        return navigationController
    }
    
    private func makeWatchlistModule() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .green
        
        let item = UITabBarItem()
        item.title = "Watchlist"
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.viewControllers = [viewController]
        navigationController.tabBarItem = item
        
        return navigationController
    }
    
    private func makeSettingsModule() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .blue
        
        let item = UITabBarItem()
        item.title = "Settings"
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.viewControllers = [viewController]
        navigationController.tabBarItem = item
        
        return navigationController
    }
}
