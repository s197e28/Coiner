//
//  WatchlistBuilder.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Swinject

final class WatchlistBuilder: WatchlistBuilderProtocol {
    
    private let resolver: Resolver
    private let coincapApiService: CoincapApiServiceProtocol
    private let assetsManager: AssetsManagerProtocol
    private let assetsLogoManager: AssetsLogoManagerProtocol
    
    init(resolver: Resolver,
         coincapApiService: CoincapApiServiceProtocol,
         assetsManager: AssetsManagerProtocol,
         assetsLogoManager: AssetsLogoManagerProtocol) {
        self.resolver = resolver
        self.coincapApiService = coincapApiService
        self.assetsManager = assetsManager
        self.assetsLogoManager = assetsLogoManager
    }
    
    convenience init(resolver: Resolver) {
        self.init(resolver: resolver,
                  coincapApiService: resolver.resolve(CoincapApiServiceProtocol.self)!,
                  assetsManager: resolver.resolve(AssetsManagerProtocol.self)!,
                  assetsLogoManager: resolver.resolve(AssetsLogoManagerProtocol.self)!)
    }
    
    func make() -> UIViewController {
        let viewController = WatchlistViewController()
        let interactor = WatchlistInteractor(
            coincapApiService: coincapApiService,
            assetsManager: assetsManager,
            assetsLogoManager: assetsLogoManager)
        let router = WatchlistRouter(resolver: resolver, viewController: viewController)
        let presenter = WatchlistPresenter(view: viewController, interactor: interactor, router: router)
        
        viewController.presenter = presenter
        interactor.output = presenter
        
        return viewController
    }
}
