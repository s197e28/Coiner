//
//  AssetEntity.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

struct AssetEntity: Codable {
    
    var id: String
    
    var symbol: String
    
    var name: String
    
    var price: Decimal?
    
    var marketCap: Decimal?
    
    var changePercentage: Float?
    
    var volume24Hr: Decimal?
    
    var supply: Decimal?
}
