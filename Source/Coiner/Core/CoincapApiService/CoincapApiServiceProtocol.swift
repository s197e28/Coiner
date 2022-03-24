//
//  CoincapApiServiceProtocol.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

enum CoincapApiServiceError: Error {
    
    case network
    
    case unknown
}

protocol CoincapApiServiceProtocol {
    
    func assets(search: String?, ids: [String]?, limit: Int?, offset: Int?, completion: @escaping (Result<AssetsResponseModel, Error>) -> Void) -> URLSessionTask
    
    func asset(id: String, completion: @escaping (Result<AssetResponseModel, Error>) -> Void) -> URLSessionTask
}

extension CoincapApiServiceProtocol {
    
    func assets(search: String? = nil, ids: [String]? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping (Result<AssetsResponseModel, Error>) -> Void) -> URLSessionTask {
        assets(search: search, ids: ids, limit: limit, offset: offset, completion: completion)
    }
}
