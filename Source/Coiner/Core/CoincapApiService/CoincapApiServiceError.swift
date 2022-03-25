//
//  CoincapApiServiceError.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

enum CoincapApiServiceError: LocalizedError {
    
    case cancelled
    
    case network
    
    case unknown
}

extension CoincapApiServiceError {
    
    public var errorDescription: String? {
        switch self {
        case .network:
            return loc("InternetConnectionError")
        case .unknown:
            return loc("UnknownError")
        default:
            return nil
        }
    }
}
