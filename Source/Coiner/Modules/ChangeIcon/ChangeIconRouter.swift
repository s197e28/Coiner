//
//  ChangeIconRouter.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Swinject

final class ChangeIconRouter: ChangeIconRouterProtocol {
    
    private var resolver: Resolver
    private(set) weak var viewController: UIViewController?
    
    init(resolver: Resolver, viewController: UIViewController) {
        self.resolver = resolver
        self.viewController = viewController
    }
}
