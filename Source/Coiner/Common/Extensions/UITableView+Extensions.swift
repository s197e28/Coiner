//
//  UITableView+Extensions.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit

extension UITableView {
    
    public func register(cellType: UITableViewCell.Type) {
        register(cellType, forCellReuseIdentifier: cellType.identifier)
    }
    
    public func dequeue<Element: UITableViewCell>(cellType: Element.Type, for indexPath: IndexPath) -> Element {
        let cell = dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath)
        
        guard let element = cell as? Element else {
            fatalError("Cell \(cell) cannot be casted as \(cellType.identifier)")
        }
        
        return element
    }
}
