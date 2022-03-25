//
//  AssetsBuilder.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Swinject

final class AssetsBuilder: AssetsBuilderProtocol {
    
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
    
    func make() -> UIViewController {
        let viewController = AssetsViewController()
        let interactor = AssetsInteractor(
            coincapApiService: coincapApiService,
            assetsManager: assetsManager)
        let router = AssetsRouter(resolver: resolver, viewController: viewController)
        let presenter = AssetsPresenter(view: viewController, interactor: interactor, router: router)
        
        viewController.presenter = presenter
        interactor.output = presenter
        
        return viewController
    }
}
