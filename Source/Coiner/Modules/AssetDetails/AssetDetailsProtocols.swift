//
//  AssetDetailsProtocols.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Combine

// MARK: Builder

protocol AssetDetailsBuilderProtocol: AnyObject {
    
    func make(asset: AssetEntity) -> UIViewController
}

//MARK: Router

protocol AssetDetailsRouterProtocol: ModuleRouterProtocol {
    
}

//MARK: View -> Presenter

protocol AssetDetailsViewOutputProtocol: AnyObject {
    
    func viewDidLoad()
    
    func didTapFavouriteButton()
}

// MARK: Presenter -> Interactor

protocol AssetDetailsInteractorInputProtocol: AnyObject {
    
    func isInWatchlist(asset: AssetEntity) -> Bool
    
    func fetchAssetHistory(with id: String)
    
    func fetchAssetDetails(with id: String)
    
    func addToWatchlist(asset: AssetEntity)
    
    func removeFromWatchlist(asset: AssetEntity)
}

//MARK: Interactor -> Presenter

protocol AssetDetailsInteractorOutputProtocol: AnyObject {
    
    func onAssetAddToWatchlist(asset: AssetEntity)
    
    func onAssetRemoveFromWatchlist(asset: AssetEntity)
    
    func didFetchAssetHistory(items: [HistoryPointEntity])
    
    func didFailedFetchAssetHistory(_ error: Error)
    
    func didFetchAssetDetails(item: AssetEntity)
    
    func didFailedFetchAssetDetails(_ error: Error)
}

//MARK: Presenter -> ViewController

protocol AssetDetailsViewInputProtocol: AnyObject {
    
    func setTitle(text: String?, details: String?)
    
    func setHeader(text: String?)
    
    func setSubheader(text: String?, isPositive: Bool)
    
    func reloadTableView(with collection: ConfigurableCollectionProtocol)
    
    func setFavouriteButton(filled: Bool)
    
    func drawChart(points: [Float], minLabelText: String?, maxLabelText: String?)
}
