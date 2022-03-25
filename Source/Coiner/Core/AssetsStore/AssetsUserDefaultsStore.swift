//
//  AssetsUserDefaultsStore.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

final class AssetsUserDefaultsStore: AssetsStoreProtocol {
    
    private let queue: DispatchQueue
    private let userDefaults: UserDefaults
    private let assetsKey = "assets"
    
    init() {
        self.queue = DispatchQueue(label: "com.coiner.assetsStore", attributes: .concurrent)
        self.userDefaults = UserDefaults.standard
    }
    
    func add(asset: AssetEntity) {
        queue.async(flags: .barrier) {
            var assets = self.getList()
            
            guard let existedIndex = assets.firstIndex(where: { $0.id == asset.id }) else {
                assets.append(asset)
                self.setList(assets)
                return
            }
            
            assets[existedIndex] = asset
            self.setList(assets)
        }
    }
    
    func get() -> [AssetEntity] {
        var value: [AssetEntity]!
        queue.sync {
            value = self.getList()
        }
        return value
    }
    
    func remove(with assetId: String) {
        queue.async(flags: .barrier) {
            var assets = self.getList()
            guard let assetIndex = assets.firstIndex(where: { $0.id == assetId }) else {
                return
            }
            assets.remove(at: assetIndex)
            self.setList(assets)
        }
    }
    
    // MARK: Private methods
    
    private func getList() -> [AssetEntity] {
        guard let data = userDefaults.value(forKey: assetsKey) as? Data,
              let items = try? PropertyListDecoder().decode(Array<AssetEntity>.self, from: data) else {
            return []
        }
        
        return items
    }
    
    private func setList(_ items: [AssetEntity]) {
        userDefaults.set(try? PropertyListEncoder().encode(items), forKey: assetsKey)
    }
}
