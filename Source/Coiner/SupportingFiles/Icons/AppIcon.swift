//
//  AppIcon.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

enum AppIcon: CaseIterable {
    
    case regular
    case black
    case yellow
    
    var name: String? {
        switch self {
        case .regular:
            return nil
        case .black:
            return "AppIconBlack"
        case .yellow:
            return "AppIconYellow"
        }
    }
}

extension AppIcon {
    
    var localizedName: String {
        switch self {
        case .regular:
            return loc("AppIconWhite")
        case .black:
            return loc("AppIconBlack")
        case .yellow:
            return loc("AppIconYellow")
        }
    }
}
