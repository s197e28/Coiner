//
//  ModuleRouterProtocol+Alerts.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import UIKit

struct AlertActionModel {
    
    var title: String
    
    var style: UIAlertAction.Style
    
    var handler: (() -> Void)?
}

extension ModuleRouterProtocol {
    
    func showAlert(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert, actions: [AlertActionModel]) {
        guard let viewController = viewController else {
            return
        }
        
        let alertAction = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for action in actions {
            alertAction.addAction(UIAlertAction(title: action.title, style: action.style, handler: { _ in action.handler?() }))
        }
        
        viewController.present(alertAction, animated: true, completion: nil)
    }
    
    func showAlert(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert) {
        showAlert(title: title, message: message, preferredStyle: preferredStyle, actions: [.init(title: loc("AlertOk"), style: .cancel, handler: nil)])
    }
}
