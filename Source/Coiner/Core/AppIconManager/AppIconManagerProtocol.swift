//
//  AppIconManagerProtocol.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

protocol AppIconManagerProtocol {
    
    var current: AppIcon { get }
    
    var availableIcons: [AppIcon] { get }
    
    func change(to icon: AppIcon, completion: ((Error?) -> Void)?)
}
