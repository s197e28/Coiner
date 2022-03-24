//
//  ConfigurableTableViewDataSource.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import UIKit

class ConfigurableTableViewDataSource: NSObject, UITableViewDataSource {
    
    private(set) var collection: ConfigurableCollectionProtocol?
    
    override init() {
        collection = nil
    }
    
    func update(collection: ConfigurableCollectionProtocol?) {
        self.collection = collection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        collection?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collection?.numberOfItems(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = collection?.cellType(at: indexPath),
              let cell = tableView.dequeue(cellType: cellType, for: indexPath) as? ConfigurableCellProtocol,
              let cellModel = collection?[indexPath] else {
            fatalError("Cell cannot be dequeue")
        }
        
        cell.update(model: cellModel)
        
        return cell
    }
}
