//
//  AssetDetailsBuilder.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Swinject

final class AssetDetailsBuilder: AssetDetailsBuilderProtocol {
    
    private let resolver: Resolver
    private let coincapApiService: CoincapApiServiceProtocol
    private let assetsManager: AssetsManagerProtocol
    
    init(resolver: Resolver,
         coincapApiService: CoincapApiServiceProtocol,
         assetsManager: AssetsManagerProtocol) {
        self.resolver = resolver
        self.coincapApiService = coincapApiService
        self.assetsManager = assetsManager
    }
    
    convenience init(resolver: Resolver) {
        self.init(resolver: resolver,
                  coincapApiService: resolver.resolve(CoincapApiServiceProtocol.self)!,
                  assetsManager: resolver.resolve(AssetsManagerProtocol.self)!)
    }
    
    func make(asset: AssetEntity) -> UIViewController {
        let viewController = AssetDetailsViewController()
        let interactor = AssetDetailsInteractor(
            coincapApiService: coincapApiService,
            assetsManager: assetsManager)
        let router = AssetDetailsRouter(resolver: resolver, viewController: viewController)
        let presenter = AssetDetailsPresenter(view: viewController, interactor: interactor, router: router)
        
        presenter.asset = asset
        viewController.presenter = presenter
        interactor.output = presenter
        
        return viewController
    }
}
