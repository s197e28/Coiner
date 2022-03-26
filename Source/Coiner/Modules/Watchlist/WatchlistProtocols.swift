//
//  WatchlistProtocols.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Combine

// MARK: Builder

protocol WatchlistBuilderProtocol: AnyObject {
    
    func make() -> UIViewController
}

//MARK: Router

protocol WatchlistRouterProtocol: ModuleRouterProtocol {
    
    func openAssetDetailsModule(asset: AssetEntity)
}

//MARK: View -> Presenter

protocol WatchlistViewOutputProtocol: AnyObject {
    
    func viewDidLoad()
    
    func viewWillAppear()
    
    func didStartRefresh()
    
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol)
    
    func didActionRemoveTableRow(at indexPath: IndexPath)
}

// MARK: Presenter -> Interactor

protocol WatchlistInteractorInputProtocol: AnyObject {
    
    func getWatchedAssets() -> [AssetEntity]
    
    func removeFromWatchlist(asset: AssetEntity)
    
    func fetchAssets(ids: [String])
    
    func retriveLogo(for asset: AssetEntity) -> UIImage?
    
    func fetchLogo(for asset: AssetEntity)
    
    func formatPrice(_ value: Decimal?) -> String
    
    func formatPercentage(_ value: Float?) -> String
    
    func isChangePositive(_ value: Float?) -> Bool
}

//MARK: Interactor -> Presenter

protocol WatchlistInteractorOutputProtocol: AnyObject {
    
    func onAssetAddToWatchlist(asset: AssetEntity)
    
    func onAssetRemoveFromWatchlist(asset: AssetEntity)
    
    func didFetchAssets(items: [AssetEntity])
    
    func didFailFetchAssets(_ error: Error)
    
    func didFetchLogo(asset: AssetEntity, image: UIImage)
}

//MARK: Presenter -> ViewController

protocol WatchlistViewInputProtocol: AnyObject {
    
    func setTitle(text: String?)
    
    func reloadTableView(with collection: ConfigurableCollectionProtocol)
    
    func deleteTableRows(at indexPaths: [IndexPath], with collection: ConfigurableCollectionProtocol)
    
    func reloadTableRows(at indexPaths: [IndexPath])
    
    func endRefreshing()
    
    func showEmptyView()
    
    func hideEmptyView()
}
