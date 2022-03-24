//
//  ChangeIconBuilder.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Swinject

final class ChangeIconBuilder: ChangeIconBuilderProtocol {
    
    private let resolver: Resolver
    private let appIconManager: AppIconManagerProtocol
    
    init(resolver: Resolver,
         appIconManager: AppIconManagerProtocol) {
        self.resolver = resolver
        self.appIconManager = appIconManager
    }
    
    convenience init(resolver: Resolver) {
        self.init(resolver: resolver,
                  appIconManager: resolver.resolve(AppIconManagerProtocol.self)!)
    }
    
    func make(output: ChangeIconOutputProtocol?) -> UIViewController {
        let viewController = ChangeIconViewController()
        let interactor = ChangeIconInteractor(appIconManager: appIconManager)
        let router = ChangeIconRouter(resolver: resolver, viewController: viewController)
        let presenter = ChangeIconPresenter(view: viewController, interactor: interactor, router: router, output: output)
        
        viewController.presenter = presenter
        interactor.output = presenter
        
        return viewController
    }
}
