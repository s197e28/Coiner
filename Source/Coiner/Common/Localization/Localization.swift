//
//  Localization.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

func loc(_ key: String, from package: LocalizationPackage = LocalizationPackage.general, with comment: String = "") -> String {
    NSLocalizedString(key, tableName: package.rawValue, comment: comment)
}
