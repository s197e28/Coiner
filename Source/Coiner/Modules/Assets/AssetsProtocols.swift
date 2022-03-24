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

protocol AssetsRouterProtocol: AnyObject {
    
}

//MARK: View -> Presenter

protocol AssetsViewOutputProtocol: AnyObject {
    
    func viewDidLoad()
        
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol)
    
    func didSearchTextChanged(_ value: String?)
    
    func didTapSearchButton()
    
    func didScrollToBottom()
}

// MARK: Presenter -> Interactor

protocol AssetsInteractorInputProtocol: AnyObject {
    
    func fetchAssets(skip: Int, take: Int)
}

//MARK: Interactor -> Presenter

protocol AssetsInteractorOutputProtocol: AnyObject {
    
    func didFetchAssets(items: [AssetModel])
    
    func didFailFetchAssets(_ error: Error)
}

//MARK: Presenter -> ViewController

protocol AssetsViewInputProtocol: AnyObject {
    
    func setTitle(text: String?)
    
    func reloadTableView(with collection: ConfigurableCollectionProtocol)
    
    func reloadSearchTableView(with collection: ConfigurableCollectionProtocol)
}
