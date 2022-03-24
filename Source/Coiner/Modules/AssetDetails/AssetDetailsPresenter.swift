//
//  AssetDetailsPresenter.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Combine

final class AssetDetailsPresenter {
    
    private weak var view: AssetDetailsViewInputProtocol?
    private let interactor: AssetDetailsInteractorInputProtocol?
    private let router: AssetDetailsRouterProtocol
    private weak var output: AssetDetailsOutputProtocol?
    
    private let tableCollection: ConfigurableCollection
    
    init(view: AssetDetailsViewInputProtocol,
         interactor: AssetDetailsInteractorInputProtocol?,
         router: AssetDetailsRouterProtocol,
         output: AssetDetailsOutputProtocol?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.output = output
        
        self.tableCollection = ConfigurableCollection()
    }
}

// MARK: View output

extension AssetDetailsPresenter: AssetDetailsViewOutputProtocol {
    
    func viewDidLoad() {
        
    }
    
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol) {
        
    }
}

// MARK: Interactor output

extension AssetDetailsPresenter: AssetDetailsInteractorOutputProtocol {
    
}
