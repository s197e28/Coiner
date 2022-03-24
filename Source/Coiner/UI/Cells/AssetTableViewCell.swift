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
        let view = UIImageView()
        
        return view
    }()
    
    private lazy var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = SemanticColor.secondaryColor
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
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(assetImageView)
        contentView.addSubview(separatorLineView)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(changeLabel)
        
        assetImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(15)
        }
        
        separatorLineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalTo(assetImageView.snp.trailing).offset(15)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(1)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.leading.equalTo(assetImageView.snp.trailing).offset(15)
            make.trailing.equalTo(priceLabel).offset(-8)
            make.bottom.equalTo(contentView.snp.centerY)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(assetImageView.snp.trailing).offset(15)
            make.trailing.equalTo(changeLabel).offset(-8)
            make.top.equalTo(contentView.snp.centerY)
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
    }
}

// MARK: Model

class AssetTableViewCellModel: ConfigurableCellModelProtocol {
    
    let id: Int?
    
    var symbolText: String?
    
    var nameText: String?
    
    var priceText: String?
    
    var changeText: String?
    
    var isChangePositive: Bool?
    
    init(id: Int? = nil,
         symbolText: String? = nil,
         nameText: String? = nil,
         priceText: String? = nil,
         changeText: String? = nil,
         isChangePositive: Bool? = nil) {
        self.id = id
        self.symbolText = symbolText
        self.nameText = nameText
        self.priceText = priceText
        self.changeText = changeText
        self.isChangePositive = isChangePositive
    }
    
    func cellType() -> ConfigurableCellProtocol.Type {
        AssetTableViewCell.self
    }
}
