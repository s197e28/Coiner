//
//  AssetsStoreProtocol.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

protocol AssetsStoreProtocol {
    
    func add(asset: AssetEntity)
    
    func get() -> [AssetEntity]
    
    func remove(with assetId: String)
}
