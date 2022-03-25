//
//  AssetDetailsViewController.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit

final class AssetDetailsViewController: UIViewController {
    
    var presenter: AssetDetailsViewOutputProtocol?
    
    private lazy var tableViewDataSource: ConfigurableTableViewDataSource = {
        ConfigurableTableViewDataSource()
    }()
    
    private lazy var heartFilledImage = UIImage(named: "heart.fill")
    private lazy var heartEmptyImage = UIImage(named: "heart.empty")
    
    private lazy var favouriteButtonAction: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(named: "heart.empty"), style: .plain, target: self, action: #selector(didTapFavouriteBarButtonAction))
    }()
    
    private lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var tableHeaderView: AssetDetailsView = {
        let view = AssetDetailsView()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .singleLine
        tableView.register(cellType: SimpleTableViewCell.self)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = favouriteButtonAction
        
        view.addSubview(tableView)
        
        tableView.tableHeaderView = tableHeaderView
        tableHeaderView.frame.size = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        tableHeaderView.setProgress(visible: true)
        tableHeaderView.chartView.isHidden = false
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func didTapFavouriteBarButtonAction(_ button: UIBarButtonItem) {
        presenter?.didTapFavouriteButton()
    }
}

// MARK: View Input

extension AssetDetailsViewController: AssetDetailsViewInputProtocol {
    
    func setTitle(text: String?, details: String?) {
        let finalString = NSMutableAttributedString()
        if let text = text {
            finalString.append(NSAttributedString(string: "\(text) ", attributes: [NSAttributedString.Key.foregroundColor: SemanticColor.primaryTextColor]))
        }
        if let details = details {
            finalString.append(NSAttributedString(string: details, attributes: [NSAttributedString.Key.foregroundColor: SemanticColor.secondaryTextColor]))
        }
        navigationTitleLabel.attributedText = finalString
        navigationItem.titleView = navigationTitleLabel
    }
    
    func setHeader(text: String?) {
        tableHeaderView.textLabel.text = text
        tableHeaderView.frame.size = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    func setSubheader(text: String?, isPositive: Bool) {
        tableHeaderView.descriptionLabel.text = text
        tableHeaderView.descriptionLabel.textColor = isPositive ? SemanticColor.positiveTextColor : SemanticColor.negativeTextColor
        tableHeaderView.frame.size = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    func reloadTableView(with collection: ConfigurableCollectionProtocol) {
        tableViewDataSource.update(collection: collection)
        tableView.reloadData()
    }
    
    func setFavouriteButton(filled: Bool) {
        favouriteButtonAction.image = filled ? heartFilledImage : heartEmptyImage
    }
    
    func drawChart(points: [Float], minLabelText: String?, maxLabelText: String?) {
        tableHeaderView.chartView.drawPoints(points: points, minLabelText: maxLabelText, maxLabelText: minLabelText) { [weak self] in
            self?.tableHeaderView.setProgress(visible: false)
            self?.tableHeaderView.chartView.isHidden = false
        }
    }
}

// MARK: UITableView delegate

extension AssetDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
