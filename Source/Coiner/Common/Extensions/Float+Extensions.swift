//
//  Float+Extensions.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

extension Float {
    
    func percentFormat() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return (formatter.string(for: self) ?? "") + "%"
    }
}
