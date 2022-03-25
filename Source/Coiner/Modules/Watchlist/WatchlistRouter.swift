//
//  WatchlistRouter.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Swinject

final class WatchlistRouter: WatchlistRouterProtocol {
    
    private var resolver: Resolver
    weak var viewController: UIViewController?
    
    init(resolver: Resolver, viewController: UIViewController) {
        self.resolver = resolver
        self.viewController = viewController
    }
    
    func openAssetDetailsModule(asset: AssetEntity) {
        guard let navigationController = viewController?.navigationController,
              let builder = resolver.resolve(AssetDetailsBuilderProtocol.self) else {
            return
        }
        
        let vc = builder.make(asset: asset)
        navigationController.show(vc, sender: nil)
    }
}
