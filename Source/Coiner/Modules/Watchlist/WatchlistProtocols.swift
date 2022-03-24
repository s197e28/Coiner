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

protocol WatchlistRouterProtocol: AnyObject {
    
}

//MARK: View -> Presenter

protocol WatchlistViewOutputProtocol: AnyObject {
    
    func viewDidLoad()
        
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol)
}

// MARK: Presenter -> Interactor

protocol WatchlistInteractorInputProtocol: AnyObject {
    
}

//MARK: Interactor -> Presenter

protocol WatchlistInteractorOutputProtocol: AnyObject {
    
}

//MARK: Presenter -> ViewController

protocol WatchlistViewInputProtocol: AnyObject {
    
    func setTitle(text: String?)
    
    func reloadTableView(with collection: ConfigurableCollectionProtocol)
}
