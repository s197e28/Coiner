//
//  AppIconManagerProtocol.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

/// Use this manager for change appilcation icon.
protocol AppIconManagerProtocol {
    
    /// Current icon of application
    var current: AppIcon { get }
    
    /// Icons is available for set
    var availableIcons: [AppIcon] { get }
    
    /// Use this method to set application icon.
    /// - Parameter to: `AppIcon` you want to set
    func change(to icon: AppIcon, completion: ((Error?) -> Void)?)
}
