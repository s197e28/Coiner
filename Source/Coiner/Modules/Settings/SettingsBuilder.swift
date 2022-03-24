//
//  SettingsBuilder.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Swinject

final class SettingsBuilder: SettingsBuilderProtocol {
    
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
    
    func make() -> UIViewController {
        let viewController = SettingsViewController()
        let interactor = SettingsInteractor(appIconManager: appIconManager)
        let router = SettingsRouter(resolver: resolver, viewController: viewController)
        let presenter = SettingsPresenter(view: viewController, interactor: interactor, router: router)
        
        viewController.presenter = presenter
        interactor.output = presenter
        
        return viewController
    }
}
