//
//  AssetModel+Map.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

extension AssetEntity {
    
    init(from model: AssetModel) {
        self.init(id: model.id,
                  symbol: model.symbol,
                  name: model.name,
                  price: Decimal(string: model.priceUsd ?? ""),
                  marketCap: Decimal(string: model.marketCapUsd ?? ""),
                  changePercentage: Float(model.changePercent24Hr ?? ""),
                  volume24Hr: Decimal(string: model.volumeUsd24Hr ?? ""),
                  supply: Decimal(string: model.supply ?? ""))
    }
}
