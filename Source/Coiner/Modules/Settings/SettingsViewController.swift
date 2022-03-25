//
//  SettingsViewController.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import SnapKit

final class SettingsViewController: UIViewController {
    
    var presenter: SettingsViewOutputProtocol?
    
    private lazy var tableViewDataSource: ConfigurableTableViewDataSource = {
        ConfigurableTableViewDataSource()
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(cellType: SimpleTableViewCell.self)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        if #available(iOS 13, *) { } else {
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: View Input

extension SettingsViewController: SettingsViewInputProtocol {
    
    func setTitle(text: String?) {
        navigationItem.title = text
    }
    
    func reloadTableView(with collection: ConfigurableCollectionProtocol) {
        tableViewDataSource.update(collection: collection)
        tableView.reloadData()
    }
}

// MARK: UITableView delegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        guard let model = tableViewDataSource.collection?[indexPath] else {
            return
        }
        
        presenter?.didSelectTableRow(model)
    }
}
