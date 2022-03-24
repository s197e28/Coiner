//
//  ChangeIconProtocols.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Combine

// MARK: Builder

protocol ChangeIconBuilderProtocol: AnyObject {
    
    func make(output: ChangeIconOutputProtocol?) -> UIViewController
}

//MARK: Router

protocol ChangeIconRouterProtocol: ModuleRouterProtocol {
    
}

//MARK: View -> Presenter

protocol ChangeIconViewOutputProtocol: AnyObject {
    
    func viewDidLoad()
        
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol)
}

// MARK: Presenter -> Interactor

protocol ChangeIconInteractorInputProtocol: AnyObject {
    
    var availableIcons: [AppIcon] { get }
    
    var currentIcon: AppIcon { get }
    
    func change(to icon: AppIcon)
}

//MARK: Interactor -> Presenter

protocol ChangeIconInteractorOutputProtocol: AnyObject {
    
    func didChange(icon: AppIcon)
    
    func didFailChange(_ error: Error)
}

//MARK: Presenter -> ViewController

protocol ChangeIconViewInputProtocol: AnyObject {
    
    func setTitle(text: String?)
    
    func reloadTableView(with collection: ConfigurableCollectionProtocol)
}

// MARK: Output

protocol ChangeIconOutputProtocol: AnyObject {
    
    func changeIconDidSuccess(_ icon: AppIcon)
}
