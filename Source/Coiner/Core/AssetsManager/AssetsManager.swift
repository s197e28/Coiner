//
//  AssetsManager.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import Swinject

final class AssetsManager: AssetsManagerProtocol {
    
    private let assetsStore: AssetsStoreProtocol
    
    private lazy var subscribers: [WeakBox<AssetsManagerSubscriberProtocol>] = []
    
    init(assetsStore: AssetsStoreProtocol) {
        self.assetsStore = assetsStore
    }
    
    convenience init(resolver: Resolver) {
        self.init(assetsStore: resolver.resolve(AssetsStoreProtocol.self)!)
    }
    
    func subscribe(_ subscriber: AssetsManagerSubscriberProtocol) {
        subscribers.append(WeakBox(subscriber))
    }
    
    func unsubscribe(_ subscriber: AssetsManagerSubscriberProtocol) {
        subscribers.removeAll(where: { $0.value === subscriber })
    }
    
    func addToWatchlist(asset: AssetEntity) {
        assetsStore.add(asset: asset)
        
        subscribers.forEach({ $0.value?.assetDidAddToWatchlist(asset) })
    }
    
    func removeFromWatchlist(asset: AssetEntity) {
        assetsStore.remove(with: asset.id)
        
        subscribers.forEach({ $0.value?.assetDidRemoveFromWatchlist(asset) })
    }
    
    func getWatchedAssets() -> [AssetEntity] {
        assetsStore.get()
    }
    
    func isInWatchlist(asset: AssetEntity) -> Bool {
        let items = assetsStore.get()
        return items.contains(where: { $0.id == asset.id })
    }
}
