//
//  AssetsManagerSubscriberProtocol.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

protocol AssetsManagerSubscriberProtocol: AnyObject {
    
    func assetDidAddToWatchlist(_ asset: AssetEntity)
    
    func assetDidRemoveFromWatchlist(_ asset: AssetEntity)
}
