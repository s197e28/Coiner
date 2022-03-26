//
//  AssetsStoreProtocol.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

/// Service for managing assets. Use this for save, get and remove models.
/// @mockable
protocol AssetsStoreProtocol: AnyObject {
    
    func add(asset: AssetEntity)
    
    func get() -> [AssetEntity]
    
    func remove(with assetId: String)
}
