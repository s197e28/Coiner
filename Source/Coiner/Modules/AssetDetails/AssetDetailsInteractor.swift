//
//  AssetDetailsInteractor.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import Combine

final class AssetDetailsInteractor: AssetDetailsInteractorInputProtocol {
    
    weak var output: AssetDetailsInteractorOutputProtocol?
    
    private let millisecondsIn24Hours: Float = 86400000 // 24 * 60 * 60 * 1000
    
    private let coincapApiService: CoincapApiServiceProtocol
    private let assetsManager: AssetsManagerProtocol
    
    init(coincapApiService: CoincapApiServiceProtocol,
         assetsManager: AssetsManagerProtocol) {
        self.coincapApiService = coincapApiService
        self.assetsManager = assetsManager
        
        self.assetsManager.subscribe(self)
    }
    
    deinit {
        self.assetsManager.unsubscribe(self)
    }
    
    func isInWatchlist(asset: AssetEntity) -> Bool {
        assetsManager.isInWatchlist(asset: asset)
    }
    
    func fetchAssetDetails(with id: String) {
        _ = coincapApiService.assetDetails(id: id, completion: { [weak self] (result) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let model):
                let entity = AssetEntity(from: model.data)
                self.output?.didFetchAssetDetails(item: entity)
            case .failure(let error):
                self.output?.didFailedFetchAssetDetails(error)
            }
        })
    }
    
    func fetchAssetHistory(with id: String) {
        _ = coincapApiService.history(id: id, interval: .m5) { [weak self] (result) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let model):
                // Filter items form last 24 hours
                var items = model.data.sorted(by: { $0.time < $1.time })
                let maxTime = items.max(by: { $0.time < $1.time })?.time ?? 0
                let minTimeForFilter = max(Float(0), maxTime - self.millisecondsIn24Hours)
                items = items.filter({ $0.time >= minTimeForFilter })
                let models = items.map({
                    HistoryPointEntity(price: Decimal(string: $0.priceUsd) ?? 0, time: Date())
                })
                self.output?.didFetchAssetHistory(items: models)
            case .failure(let error):
                self.output?.didFailedFetchAssetHistory(error)
            }
        }
    }
    
    func addToWatchlist(asset: AssetEntity) {
        assetsManager.addToWatchlist(asset: asset)
    }
    
    func removeFromWatchlist(asset: AssetEntity) {
        assetsManager.removeFromWatchlist(asset: asset)
    }
    
    func formatPrice(_ value: Decimal?, maxFractionDigits: Int, empty: String) -> String {
        guard let value = value else {
            return empty
        }
        
        return value < 0.1 ? value.amountFormat("$", minFractionDigits: 0, maxFractionDigits: 8) : value.amountFormat("$", maxFractionDigits: maxFractionDigits)
    }
    
    func formatPercentage(_ value: Float?) -> String {
        let value = value ?? 0
        return value.percentFormat()
    }
    
    func isChangePositive(_ value: Float?) -> Bool {
        value ?? 0 >= 0
    }
}

extension AssetDetailsInteractor: AssetsManagerSubscriberProtocol {
    
    func assetDidAddToWatchlist(_ asset: AssetEntity) {
        output?.onAssetAddToWatchlist(asset: asset)
    }
    
    func assetDidRemoveFromWatchlist(_ asset: AssetEntity) {
        output?.onAssetRemoveFromWatchlist(asset: asset)
    }
}

extension AssetDetailsInteractorInputProtocol {
    
    func formatPrice(_ value: Decimal?) -> String {
        formatPrice(value, maxFractionDigits: 2, empty: "")
    }
}
