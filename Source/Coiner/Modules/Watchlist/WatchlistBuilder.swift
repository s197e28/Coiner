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
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
//    convenience init(resolver: Resolver) {
//        self.init(
//            resolver: resolver)
//    }
    
    func make() -> UIViewController {
        let viewController = WatchlistViewController()
        let interactor = WatchlistInteractor()
        let router = WatchlistRouter(resolver: resolver, viewController: viewController)
        let presenter = WatchlistPresenter(view: viewController, interactor: interactor, router: router)
        
        viewController.presenter = presenter
        interactor.output = presenter
        
        return viewController
    }
}
