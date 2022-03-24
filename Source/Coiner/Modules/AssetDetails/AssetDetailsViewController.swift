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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(cellType: UITableViewCell.self)
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
        view.backgroundColor = UIColor.white
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: View Input

extension AssetDetailsViewController: AssetDetailsViewInputProtocol {
    
    func setTitle(text: String?) {
        navigationItem.title = text
    }
    
    func reloadTableView(with collection: ConfigurableCollectionProtocol) {
        tableViewDataSource.update(collection: collection)
        tableView.reloadData()
    }
}

// MARK: UITableView delegate

extension AssetDetailsViewController: UITableViewDelegate {
    
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
