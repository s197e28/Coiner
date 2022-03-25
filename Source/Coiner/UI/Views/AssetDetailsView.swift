//
//  AssetDetailsView.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation
import UIKit

final class AssetDetailsView: UIView {
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 64, weight: .ultraLight)
        label.textAlignment = .center
        label.textColor = SemanticColor.primaryTextColor
        label.lineBreakMode = .byTruncatingMiddle // bad solution, need resize text
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .black
        view.isHidden = true
        return view
    }()
    
    lazy var chartContainerView: UIView = UIView()
    
    lazy var chartView: ChartView = ChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(visible: Bool) {
        if visible {
            indicatorView.startAnimating()
            indicatorView.isHidden = false
        } else {
            indicatorView.stopAnimating()
            indicatorView.isHidden = true
        }
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        addSubview(textLabel)
        addSubview(descriptionLabel)
        chartContainerView.addSubview(indicatorView)
        chartContainerView.addSubview(chartView)
        addSubview(chartContainerView)
        
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        chartContainerView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(7)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        chartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
