//
//  CoincapApiServiceProtocol.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

protocol CoincapApiServiceProtocol {
    
    func assets(search: String?, ids: [String]?, limit: Int?, offset: Int?, completion: @escaping (Result<AssetsResponseModel, Error>) -> Void) -> URLSessionTask
    
    func assetDetails(id: String, completion: @escaping (Result<AssetDetailsResponseModel, Error>) -> Void) -> URLSessionTask
    
    func history(id: String, interval: HistoryInterval, completion: @escaping (Result<HistoryResponseModel, Error>) -> Void) -> URLSessionTask
}

extension CoincapApiServiceProtocol {
    
    func assets(search: String? = nil, ids: [String]? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping (Result<AssetsResponseModel, Error>) -> Void) -> URLSessionTask {
        assets(search: search, ids: ids, limit: limit, offset: offset, completion: completion)
    }
}
