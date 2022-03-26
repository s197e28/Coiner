//
//  MainBuilder.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/23/22.
//

import UIKit
import Swinject

final class MainBuilder: MainBuilderProtocol {
    
    private let assetsBuilder: AssetsBuilderProtocol
    private let watchlistBuilder: WatchlistBuilderProtocol
    private let settingsBuilder: SettingsBuilderProtocol
    
    init(assetsBuilder: AssetsBuilderProtocol,
         watchlistBuilder: WatchlistBuilderProtocol,
         settingsBuilder: SettingsBuilderProtocol) {
        self.assetsBuilder = assetsBuilder
        self.watchlistBuilder = watchlistBuilder
        self.settingsBuilder = settingsBuilder
    }
    
    convenience init(resolver: Resolver) {
        self.init(assetsBuilder: resolver.resolve(AssetsBuilderProtocol.self)!,
                  watchlistBuilder: resolver.resolve(WatchlistBuilderProtocol.self)!,
                  settingsBuilder: resolver.resolve(SettingsBuilderProtocol.self)!)
    }
    
    func make() -> UIViewController {
        let viewController = MainViewController()
        
        viewController.navigationController?.navigationBar.isHidden = true
        viewController.viewControllers = [makeAssetsModule(), makeWatchlistModule(), makeSettingsModule()]
        viewController.selectedIndex = 0
        
        return viewController
    }
    
    private func makeAssetsModule() -> UIViewController {
        let vc = assetsBuilder.make()
        
        let item = UITabBarItem()
        item.title = loc("TabTitleAssets")
        item.image = UIImage(named: "bitcoinsign.circle.fill")
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.viewControllers = [vc]
        navigationController.tabBarItem = item
        navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
    
    private func makeWatchlistModule() -> UIViewController {
        let vc = watchlistBuilder.make()
        
        let item = UITabBarItem()
        item.title = loc("TabTitleWatchlist")
        item.image = UIImage(named: "heart.fill")
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.viewControllers = [vc]
        navigationController.tabBarItem = item
        navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
    
    private func makeSettingsModule() -> UIViewController {
        let vc = settingsBuilder.make()
        
        let item = UITabBarItem()
        item.title = loc("TabTitleSettings")
        item.image = UIImage(named: "gearshape.fill")
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.viewControllers = [vc]
        navigationController.tabBarItem = item
        navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
}
