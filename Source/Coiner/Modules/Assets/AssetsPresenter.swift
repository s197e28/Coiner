//
//  AssetsPresenter.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Combine

final class AssetsPresenter {
    
    private weak var view: AssetsViewInputProtocol?
    private let interactor: AssetsInteractorInputProtocol?
    private let router: AssetsRouterProtocol
    
    private let tableCollection: ConfigurableCollection
    private let searchTableCollection: ConfigurableCollection
    
    init(view: AssetsViewInputProtocol,
         interactor: AssetsInteractorInputProtocol?,
         router: AssetsRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.tableCollection = ConfigurableCollection()
        self.searchTableCollection = ConfigurableCollection()
    }
}

// MARK: View output

extension AssetsPresenter: AssetsViewOutputProtocol {
    
    func viewDidLoad() {
        view?.setTitle(text: loc("ModuleTitle", from: .assets))
        
        interactor?.fetchAssets(skip: 0, take: 15)
    }
    
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol) {
        
    }
    
    func didSearchTextChanged(_ value: String?) {
        
    }
    
    func didTapSearchButton() {
        
    }
    
    func didScrollToBottom() {
        interactor?.fetchAssets(skip: 0, take: 15)
    }
}

// MARK: Interactor output

extension AssetsPresenter: AssetsInteractorOutputProtocol {
    
    func didFetchAssets(items: [AssetModel]) {
        let cellModels = items.map { (item) in
            
            AssetTableViewCellModel(symbolText: item.symbol, nameText: item.name, priceText: item.priceUsd, changeText: item.changePercent24Hr, isChangePositive: true)
        }
        tableCollection.add(items: cellModels)
        
        DispatchQueue.main.async {
            self.view?.reloadTableView(with: self.tableCollection)
        }
        
    }
    
    func didFailFetchAssets(_ error: Error) {
        
    }
}
