//
//  AssetsInteractor.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import UIKit

final class AssetsInteractor: AssetsInteractorInputProtocol {
    
    weak var output: AssetsInteractorOutputProtocol?
    
    private let coincapApiService: CoincapApiServiceProtocol
    private let assetsManager: AssetsManagerProtocol
    private let assetsLogoManager: AssetsLogoManagerProtocol
    
    init(coincapApiService: CoincapApiServiceProtocol,
         assetsManager: AssetsManagerProtocol,
         assetsLogoManager: AssetsLogoManagerProtocol) {
        self.coincapApiService = coincapApiService
        self.assetsManager = assetsManager
        self.assetsLogoManager = assetsLogoManager
    }
    
    func fetchAssets(search: String?, skip: Int, take: Int) -> URLSessionTask {
        coincapApiService.assets(search: search, limit: take, offset: skip) { [weak self] (result) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let model):
                let items = model.data.map({ AssetEntity(from: $0) })
                self.output?.didFetchAssets(items: items)
            case .failure(let error) where error as? CoincapApiServiceError != CoincapApiServiceError.cancelled:
                self.output?.didFailFetchAssets(error)
            case .failure:
                break
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
