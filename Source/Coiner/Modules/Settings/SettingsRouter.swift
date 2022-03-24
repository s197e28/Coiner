//
//  SettingsRouter.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Swinject

final class SettingsRouter: SettingsRouterProtocol {
    
    private var resolver: Resolver
    private weak var viewController: UIViewController?
    
    init(resolver: Resolver, viewController: UIViewController) {
        self.resolver = resolver
        self.viewController = viewController
    }
    
    func openChangeIconModule(output: ChangeIconOutputProtocol?) {
        guard let navigationController = viewController?.navigationController,
              let builder = resolver.resolve(ChangeIconBuilderProtocol.self) else {
            return
        }
        
        let vc = builder.make(output: output)
        navigationController.show(vc, sender: nil)
//        navigationController.present(vc, animated: true, completion: nil)
    }
}
