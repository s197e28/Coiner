//
//  SettingsInteractor.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import Combine

final class SettingsInteractor: SettingsInteractorInputProtocol {
    
    weak var output: SettingsInteractorOutputProtocol?
    
    private let appIconManager: AppIconManagerProtocol
    
    init(appIconManager: AppIconManagerProtocol) {
        self.appIconManager = appIconManager
    }
    
    var currentIcon: AppIcon {
        appIconManager.current
    }
}
