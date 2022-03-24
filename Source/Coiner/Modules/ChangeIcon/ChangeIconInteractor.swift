//
//  ChangeIconInteractor.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import Combine

final class ChangeIconInteractor: ChangeIconInteractorInputProtocol {
    
    weak var output: ChangeIconInteractorOutputProtocol?
    
    private let appIconManager: AppIconManagerProtocol
    
    init(appIconManager: AppIconManagerProtocol) {
        self.appIconManager = appIconManager
    }
    
    lazy var availableIcons: [AppIcon] = {
        appIconManager.availableIcons
    }()
    
    var currentIcon: AppIcon {
        appIconManager.current
    }
    
    func change(to icon: AppIcon) {
        appIconManager.change(to: icon) { [weak self] (error) in
            if let _ = error {
                self?.output?.didFailChange(ChangeIconProcessError.unknown)
                return
            }
            
            self?.output?.didChange(icon: icon)
        }
    }
}
