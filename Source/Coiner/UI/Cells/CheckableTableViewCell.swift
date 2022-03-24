//
//  CheckableTableViewCell.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import UIKit

// MARK: Cell

final class CheckableTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
}

extension CheckableTableViewCell: ConfigurableCellProtocol {
    
    func update(model: ConfigurableCellModelProtocol) {
        guard let model = model as? CheckableTableViewCellModel else {
            return
        }
        
        textLabel?.text = model.text
        accessoryType = model.checked ? .checkmark : .none
    }
}

// MARK: Model

class CheckableTableViewCellModel: ConfigurableCellModelProtocol {
    
    let id: Int?
    
    let entity: Any?
    
    var text: String?
    
    var checked: Bool
    
    init(id: Int? = nil,
         entity: Any? = nil,
         text: String? = nil,
         checked: Bool = false) {
        self.id = id
        self.entity = entity
        self.text = text
        self.checked = checked
    }
    
    func cellType() -> ConfigurableCellProtocol.Type {
        CheckableTableViewCell.self
    }
}
