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
    
    init(coincapApiService: CoincapApiServiceProtocol) {
        self.coincapApiService = coincapApiService
    }
    
    func fetchAssets(skip: Int, take: Int) {
        let task = coincapApiService.assets(limit: take, offset: skip) { [weak self] (result) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let model):
                self.output?.didFetchAssets(items: model.data)
            case .failure(let error):
                self.output?.didFailFetchAssets(error)
            }
        }
    }
}
