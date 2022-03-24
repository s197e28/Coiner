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
    
    init(resolver: Resolver,
         coincapApiService: CoincapApiServiceProtocol) {
        self.resolver = resolver
        self.coincapApiService = coincapApiService
    }
    
    convenience init(resolver: Resolver) {
        self.init(resolver: resolver,
                  coincapApiService: resolver.resolve(CoincapApiServiceProtocol.self)!)
    }
    
    func make() -> UIViewController {
        let viewController = AssetsViewController()
        let interactor = AssetsInteractor(coincapApiService: coincapApiService)
        let router = AssetsRouter(resolver: resolver, viewController: viewController)
        let presenter = AssetsPresenter(view: viewController, interactor: interactor, router: router)
        
        viewController.presenter = presenter
        interactor.output = presenter
        
        return viewController
    }
}
