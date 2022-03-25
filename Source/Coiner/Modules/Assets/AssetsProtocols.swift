//
//  AssetsProtocols.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Combine

// MARK: Builder

protocol AssetsBuilderProtocol: AnyObject {
    
    func make() -> UIViewController
}

//MARK: Router

protocol AssetsRouterProtocol: ModuleRouterProtocol {
    
    func openAssetDetailsModule(asset: AssetEntity)
}

//MARK: View -> Presenter

protocol AssetsViewOutputProtocol: AnyObject {
    
    func viewDidLoad()
        
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol)
    
    func didStartRefresh()
    
    func didChangeSearchBarText(_ value: String?)
    
    func didTapSearchBarCancelButton()
    
    func didScrollToBottom()
}

// MARK: Presenter -> Interactor

protocol AssetsInteractorInputProtocol: AnyObject {
    
    func fetchAssets(search: String?, skip: Int, take: Int) -> URLSessionTask
}

extension AssetsInteractorInputProtocol {
    
    func fetchAssets(skip: Int, take: Int) -> URLSessionTask {
        fetchAssets(search: nil, skip: skip, take: take)
    }
}

//MARK: Interactor -> Presenter

protocol AssetsInteractorOutputProtocol: AnyObject {
    
    func didFetchAssets(items: [AssetEntity])
    
    func didFailFetchAssets(_ error: Error)
}

//MARK: Presenter -> ViewController

protocol AssetsViewInputProtocol: AnyObject {
    
    func setTitle(text: String?)
    
    func reloadTableView(with collection: ConfigurableCollectionProtocol)
    
    func reloadSearchTableView(with collection: ConfigurableCollectionProtocol)
    
    func endRefreshing()
}
