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
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
//    convenience init(resolver: Resolver) {
//        self.init(
//            resolver: resolver)
//    }
    
    func make(output: AssetDetailsOutputProtocol?) -> UIViewController {
        let viewController = AssetDetailsViewController()
        let interactor = AssetDetailsInteractor()
        let router = AssetDetailsRouter(resolver: resolver, viewController: viewController)
        let presenter = AssetDetailsPresenter(view: viewController, interactor: interactor, router: router, output: output)
        
        viewController.presenter = presenter
        interactor.output = presenter
        
        return viewController
    }
}
