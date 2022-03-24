//
//  AppIconManager.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import UIKit

final class AppIconManager: AppIconManagerProtocol {
    
    var current: AppIcon {
        let alternateIconName = UIApplication.shared.alternateIconName
        guard let currentIcon = AppIcon.allCases.first(where: { $0.name == alternateIconName }) else {
            return .regular
        }
        
        return currentIcon
    }
    
    lazy var availableIcons: [AppIcon] = {
        AppIcon.allCases
    }()
    
    func change(to icon: AppIcon, completion: ((Error?) -> Void)?) {
        guard current != icon,
              availableIcons.contains(icon) else {
            return
        }
        
        UIApplication.shared.setAlternateIconName(icon.name) { (error) in
            completion?(error)
        }
    }
}
