//
//  ConfigurableCollectionSection.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import UIKit

final class ConfigurableCollectionSection {
    
    private(set) var id: Int?
    private(set) var header: ConfigurableSectionHeaderModelProtocol?
    private(set) var items: [ConfigurableCellModelProtocol]
    
    init(id: Int? = nil,
         header: ConfigurableSectionHeaderModelProtocol? = nil,
         items: [ConfigurableCellModelProtocol]) {
        self.id = id
        self.header = header
        self.items = items
    }
    
    init() {
        self.items = []
    }
    
    func add(item: ConfigurableCellModelProtocol, at index: Int? = nil) {
        guard let index = index else {
            add(items: [item])
            return
        }
        
        items.insert(item, at: index)
    }
    
    func add(items: [ConfigurableCellModelProtocol]) {
        self.items.append(contentsOf: items)
    }
    
    func remove(at index: Int) -> ConfigurableCellModelProtocol {
        self.items.remove(at: index)
    }
}
