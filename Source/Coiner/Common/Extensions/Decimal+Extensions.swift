//
//  Decimal+Extensions.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

extension Decimal {
    
    func amountFormat(_ currencySymbol: String, minFractionDigits: Int = 0, maxFractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = minFractionDigits
        formatter.maximumFractionDigits = maxFractionDigits
        formatter.currencySymbol = currencySymbol
        return formatter.string(for: self) ?? ""
    }
}
