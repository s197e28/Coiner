//
//  AssetsManagerProtocol.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

/// Manager for handling actions on watched Assets.
protocol AssetsManagerProtocol: AnyObject {
    
    func subscribe(_ subscriber: AssetsManagerSubscriberProtocol)
    
    func unsubscribe(_ subscriber: AssetsManagerSubscriberProtocol)
    
    func addToWatchlist(asset: AssetEntity)
    
    func removeFromWatchlist(asset: AssetEntity)
    
    func getWatchedAssets() -> [AssetEntity]
    
    func isInWatchlist(asset: AssetEntity) -> Bool
}
