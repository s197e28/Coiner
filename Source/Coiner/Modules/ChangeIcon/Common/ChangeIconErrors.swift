//
//  ChangeIconErrors.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

// MARK: ChangeIconProcessError

enum ChangeIconProcessError: LocalizedError {
    
    case unknown
}

extension ChangeIconProcessError {
    
    public var errorDescription: String? {
            switch self {
            case .unknown:
                return loc("IconNotChanged", from: .сhangeIcon)
            }
        }
}
