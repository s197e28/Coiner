//
//  Common.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Swinject

protocol ConfigurableSectionHeaderModelProtocol: AnyObject {
    
    func view() -> UIView
}

protocol ConfigurableCellModelProtocol: AnyObject {
    
    var id: Int? { get }
    
    func cellType() -> ConfigurableCellProtocol.Type
}

protocol TrailingActionsCellModelProtocol: ConfigurableCellModelProtocol {
    
    var trailingActions: [String] { get }
}

protocol ConfigurableCellProtocol where Self: UITableViewCell {
    
    func update(model: ConfigurableCellModelProtocol)
}

protocol ConfigurableCollectionProtocol: AnyObject {
    
    func numberOfSections() -> Int
    
    func numberOfItems(in section: Int) -> Int
    
    func cellType(at indexPath: IndexPath) -> ConfigurableCellProtocol.Type?
    
    func section(at index: Int) -> ConfigurableSectionHeaderModelProtocol?
    
    subscript(indexPath: IndexPath) -> ConfigurableCellModelProtocol? { get }
}

protocol ConfigurableCellContextMenuInteractionProtocol {
    
    func doContext()
}
