//
//  ConfigurableCollection.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import UIKit

final class ConfigurableCollection: ConfigurableCollectionProtocol {
    
    private(set) var sections: [ConfigurableCollectionSection]
    
    init(sections: [ConfigurableCollectionSection]) {
        self.sections = sections
    }
    
    init(items: [ConfigurableCellModelProtocol]) {
        self.sections = [ConfigurableCollectionSection(items: items)]
    }
    
    init() {
        self.sections = []
    }
    
    func add(section: ConfigurableCollectionSection) {
        sections.append(section)
    }
    
    func add(item: ConfigurableCellModelProtocol, at section: Int = 0) {
        add(items: [item])
    }
    
    func add(items: [ConfigurableCellModelProtocol], at section: Int = 0) {
        if sections.isEmpty {
            sections.append(ConfigurableCollectionSection(items: items))
            return
        }
        
        guard sections.count > section else {
            fatalError("Section with index = \(section) not exist.")
        }
        
        sections[section].add(items: items)
    }
    
    func update(with items: [ConfigurableCellModelProtocol]) {
        sections.removeAll()
        add(items: items)
    }
    
    func update(with sections: [ConfigurableCollectionSection]) {
        self.sections.removeAll()
        for section in sections {
            add(section: section)
        }
    }
    
    func removeAll() {
        sections.removeAll()
    }
    
    // MARK: ConfigurableCollectionProtocol
    
    func numberOfSections() -> Int {
        sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        sections[section].items.count
    }
    
    func cellType(at indexPath: IndexPath) -> ConfigurableCellProtocol.Type? {
        sections[indexPath.section].items[indexPath.row].cellType()
    }
    
    func section(at index: Int) -> ConfigurableSectionHeaderModelProtocol? {
        guard let sectionModel = sections[safe: index] else {
            return nil
        }
        
        return sectionModel.header
    }
    
    subscript(indexPath: IndexPath) -> ConfigurableCellModelProtocol? {
        guard let sectionModel = sections[safe: indexPath.section],
              let cellModel = sectionModel.items[safe: indexPath.row] else {
            return nil
        }
        
        return cellModel
    }
}
