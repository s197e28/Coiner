//
//  AssetModel.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

struct AssetModel: Codable {
    
    var id: String
    
    var symbol: String
    
    var name: String
    
    var priceUsd: String
    
    var changePercent24Hr: String
}
