//
//  CoincapApiService.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

final class CoincapApiService: CoincapApiServiceProtocol {
    
    private let endpoint: String = "https://api.coincap.io/v2"
    private let apiToken: String = "39c8dd1a-81bb-441c-bbe8-4596bb3ae124"
    
    func assets(search: String?, ids: [String]?, limit: Int?, offset: Int?, completion: @escaping (Result<AssetsResponseModel, Error>) -> Void) -> URLSessionTask {
        var methodPath: String = "/assets?"
        if let search = search {
            methodPath += "search=\(search)&"
        }
        if let ids = ids, ids.count > 0 {
            methodPath += "ids=\(ids.joined(separator: ","))&"
        }
        if let limit = limit {
            methodPath += "limit=\(limit)&"
        }
        if let offset = offset {
            methodPath += "offset=\(offset)&"
        }
        methodPath = String(methodPath.dropLast()).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        let requestUrl = URL(string: endpoint + methodPath)
        var request = URLRequest(url: requestUrl!)
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data,
                  let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                      completion(.failure(CoincapApiServiceError.network))
                      return
                  }
            
            do {
                let model = try JSONDecoder().decode(AssetsResponseModel.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(CoincapApiServiceError.unknown))
            }
        }
        task.resume()
        return task
    }
    
    func asset(id: String, completion: @escaping (Result<AssetResponseModel, Error>) -> Void) -> URLSessionTask {
        let methodPath: String = "/assets/\(id)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        let requestUrl = URL(string: endpoint + methodPath)
        var request = URLRequest(url: requestUrl!)
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data,
                  let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                      print(String(decoding: data!, as: UTF8.self))
                      completion(.failure(CoincapApiServiceError.network))
                      return
                  }
            
            do {
                let model = try JSONDecoder().decode(AssetResponseModel.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(CoincapApiServiceError.unknown))
            }
        }
        task.resume()
        return task
    }
}
