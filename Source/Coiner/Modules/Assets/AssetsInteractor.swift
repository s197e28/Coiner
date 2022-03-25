//
//  AssetsInteractor.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

final class AssetsInteractor: AssetsInteractorInputProtocol {
    
    weak var output: AssetsInteractorOutputProtocol?
    
    private let coincapApiService: CoincapApiServiceProtocol
    private let assetsManager: AssetsManagerProtocol
    
    init(coincapApiService: CoincapApiServiceProtocol,
         assetsManager: AssetsManagerProtocol) {
        self.coincapApiService = coincapApiService
        self.assetsManager = assetsManager
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
}
