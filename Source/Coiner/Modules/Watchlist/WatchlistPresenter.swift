//
//  WatchlistPresenter.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Combine

final class WatchlistPresenter {
    
    private weak var view: WatchlistViewInputProtocol?
    private let interactor: WatchlistInteractorInputProtocol?
    private let router: WatchlistRouterProtocol
    
    private let tableCollection: ConfigurableCollection
    
    init(view: WatchlistViewInputProtocol,
         interactor: WatchlistInteractorInputProtocol?,
         router: WatchlistRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.tableCollection = ConfigurableCollection()
    }
}

// MARK: View output

extension WatchlistPresenter: WatchlistViewOutputProtocol {
    
    func viewDidLoad() {
        
    }
    
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol) {
        
    }
}

// MARK: Interactor output

extension WatchlistPresenter: WatchlistInteractorOutputProtocol {
    
}
