//
//  AssetTableViewCell.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import UIKit

// MARK: Cell

final class AssetTableViewCell: UITableViewCell {
    
    private lazy var assetImageView: UIImageView = {
        let view = UIImageView(frame: .init(x: 0, y: 0, width: 60, height: 60))
        
        return view
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textColor = SemanticColor.primaryTextColor
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = SemanticColor.secondaryTextColor
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textColor = SemanticColor.secondaryLightTextColor
        return label
    }()
    
    private lazy var changeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        symbolLabel.text = nil
        nameLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        assetImageView.image = nil
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(assetImageView)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(changeLabel)
        
        assetImageView.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalTo(assetImageView.snp.trailing).offset(15)
            make.trailing.equalTo(priceLabel).offset(-8)
            make.bottom.equalTo(contentView.snp.centerY)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(assetImageView.snp.trailing).offset(15)
            make.trailing.equalTo(changeLabel).offset(-8)
            make.top.equalTo(contentView.snp.centerY)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(contentView.snp.centerY)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(contentView.snp.centerY)
        }
    }
}

extension AssetTableViewCell: ConfigurableCellProtocol {
    
    func update(model: ConfigurableCellModelProtocol) {
        guard let model = model as? AssetTableViewCellModel else {
            return
        }
        
        symbolLabel.text = model.symbolText
        nameLabel.text = model.nameText
        priceLabel.text = model.priceText
        changeLabel.text = model.changeText
        changeLabel.textColor = model.isChangePositive == true ? SemanticColor.positiveTextColor : SemanticColor.negativeTextColor
        if let image = model.image {
            assetImageView.image = image
        }
    }
}

// MARK: Model

class AssetTableViewCellModel: ConfigurableCellModelProtocol {
    
    let id: Int?
    
    var entity: Any?
    
    var symbolText: String?
    
    var nameText: String?
    
    var priceText: String?
    
    var changeText: String?
    
    var isChangePositive: Bool?
    
    var image: UIImage?
    
    init(id: Int? = nil,
         entity: Any?,
         symbolText: String? = nil,
         nameText: String? = nil,
         priceText: String? = nil,
         changeText: String? = nil,
         isChangePositive: Bool? = nil,
         image: UIImage? = nil) {
        self.id = id
        self.entity = entity
        self.symbolText = symbolText
        self.nameText = nameText
        self.priceText = priceText
        self.changeText = changeText
        self.isChangePositive = isChangePositive
        self.image = image
    }
    
    func cellType() -> ConfigurableCellProtocol.Type {
        AssetTableViewCell.self
    }
}
