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
    
    func make(output: AssetDetailsOutputProtocol?) -> UIViewController
}

//MARK: Router

protocol AssetDetailsRouterProtocol: AnyObject {
    
}

//MARK: View -> Presenter

protocol AssetDetailsViewOutputProtocol: AnyObject {
    
    func viewDidLoad()
        
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol)
}

// MARK: Presenter -> Interactor

protocol AssetDetailsInteractorInputProtocol: AnyObject {
    
}

//MARK: Interactor -> Presenter

protocol AssetDetailsInteractorOutputProtocol: AnyObject {
    
}

//MARK: Presenter -> ViewController

protocol AssetDetailsViewInputProtocol: AnyObject {
    
    func setTitle(text: String?)
    
    func reloadTableView(with collection: ConfigurableCollectionProtocol)
}

// MARK: Output

protocol AssetDetailsOutputProtocol: AnyObject {
    
}
