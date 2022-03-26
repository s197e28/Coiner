//
//  WatchlistInteractor.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import Combine
import UIKit

final class WatchlistInteractor: WatchlistInteractorInputProtocol {
    
    weak var output: WatchlistInteractorOutputProtocol?
    
    private let coincapApiService: CoincapApiServiceProtocol
    private let assetsManager: AssetsManagerProtocol
    private let assetsLogoManager: AssetsLogoManagerProtocol
    
    init(coincapApiService: CoincapApiServiceProtocol,
         assetsManager: AssetsManagerProtocol,
         assetsLogoManager: AssetsLogoManagerProtocol) {
        self.coincapApiService = coincapApiService
        self.assetsManager = assetsManager
        self.assetsLogoManager = assetsLogoManager
        
        self.assetsManager.subscribe(self)
    }
    
    deinit {
        self.assetsManager.unsubscribe(self)
    }
    
    func getWatchedAssets() -> [AssetEntity] {
        assetsManager.getWatchedAssets()
    }
    
    func removeFromWatchlist(asset: AssetEntity) {
        assetsManager.removeFromWatchlist(asset: asset)
    }
    
    func fetchAssets(ids: [String]) {
        _ = coincapApiService.assets(ids: ids) { [weak self] (result) in
            switch result {
            case .success(let model):
                let items = model.data.map({ AssetEntity(from: $0) })
                self?.output?.didFetchAssets(items: items)
            case .failure(let error):
                self?.output?.didFailFetchAssets(error)
            }
        }
    }
    
    func retriveLogo(for asset: AssetEntity) -> UIImage? {
        assetsLogoManager.retrive(assetSymbol: asset.symbol)
    }
    
    func fetchLogo(for asset: AssetEntity) {
        assetsLogoManager.fetch(assetSymbol: asset.symbol) { [weak self] (image) in
            guard let image = image else {
                // TODO: Handle
                return
            }
            
            self?.output?.didFetchLogo(asset: asset, image: image)
        }
    }
    
    func formatPrice(_ value: Decimal?) -> String {
        let value = value ?? 0
        return value < 0.1 ? value.amountFormat("$", minFractionDigits: 0, maxFractionDigits: 8) : value.amountFormat("$")
    }
    
    func formatPercentage(_ value: Float?) -> String {
        let value = value ?? 0
        return value.percentFormat()
    }
    
    func isChangePositive(_ value: Float?) -> Bool {
        value ?? 0 >= 0
    }
}

extension WatchlistInteractor: AssetsManagerSubscriberProtocol {
    
    func assetDidAddToWatchlist(_ asset: AssetEntity) {
        output?.onAssetAddToWatchlist(asset: asset)
    }
    
    func assetDidRemoveFromWatchlist(_ asset: AssetEntity) {
        output?.onAssetRemoveFromWatchlist(asset: asset)
    }
}
