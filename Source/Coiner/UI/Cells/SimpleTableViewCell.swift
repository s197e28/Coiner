//
//  SimpleTableViewCell.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import UIKit

// MARK: Cell

final class SimpleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        accessoryType = .none
    }
}

extension SimpleTableViewCell: ConfigurableCellProtocol {
    
    func update(model: ConfigurableCellModelProtocol) {
        guard let model = model as? SimpleTableViewCellModel else {
            return
        }
        
        textLabel?.text = model.text
        detailTextLabel?.text = model.detailsText
        accessoryType = model.accessoryType
    }
}

// MARK: Model

class SimpleTableViewCellModel: ConfigurableCellModelProtocol {
    
    let id: Int?
    
    var text: String?
    
    var detailsText: String?
    
    var accessoryType: UITableViewCell.AccessoryType
    
    init(id: Int? = nil,
         text: String? = nil,
         detailsText: String? = nil,
         accessoryType: UITableViewCell.AccessoryType = .none) {
        self.id = id
        self.text = text
        self.detailsText = detailsText
        self.accessoryType = accessoryType
    }
    
    func cellType() -> ConfigurableCellProtocol.Type {
        SimpleTableViewCell.self
    }
}
