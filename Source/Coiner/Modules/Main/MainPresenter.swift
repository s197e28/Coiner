//
//  MainPresenter.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/23/22.
//

import UIKit
import Combine

final class MainPresenter {
    
    private weak var view: MainViewInputProtocol?
    
    init(view: MainViewInputProtocol) {
        self.view = view
    }
}

// MARK: View output

extension MainPresenter: MainViewOutputProtocol {
    
    func viewDidLoad() {
        
    }
}
