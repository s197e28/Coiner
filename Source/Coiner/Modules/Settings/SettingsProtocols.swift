//
//  SettingsProtocols.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Combine

// MARK: Builder

protocol SettingsBuilderProtocol: AnyObject {
    
    func make() -> UIViewController
}

//MARK: Router

protocol SettingsRouterProtocol: AnyObject {
    
    func openChangeIconModule(output: ChangeIconOutputProtocol?)
}

//MARK: View -> Presenter

protocol SettingsViewOutputProtocol: AnyObject {
    
    func viewDidLoad()
        
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol)
}

// MARK: Presenter -> Interactor

protocol SettingsInteractorInputProtocol: AnyObject {
    
    var currentIcon: AppIcon { get }
}

//MARK: Interactor -> Presenter

protocol SettingsInteractorOutputProtocol: AnyObject {
    
}

//MARK: Presenter -> ViewController

protocol SettingsViewInputProtocol: AnyObject {
    
    func setTitle(text: String?)
    
    func reloadTableView(with collection: ConfigurableCollectionProtocol)
}
