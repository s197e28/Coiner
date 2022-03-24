//
//  LocalizationPackage.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

struct LocalizationPackage: RawRepresentable {
    
    var rawValue: String
    
    static let general = LocalizationPackage(rawValue: "Localizable")
}
