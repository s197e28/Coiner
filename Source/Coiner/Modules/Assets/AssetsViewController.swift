//
//  AssetsViewController.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit

final class AssetsViewController: UIViewController {
    
    var presenter: AssetsViewOutputProtocol?
    
    private lazy var searchResultsViewController: AssetsSearchResultsViewController = {
        let viewController = AssetsSearchResultsViewController()
        viewController.presenter = presenter
        return viewController
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.delegate = self
//        searchController.showsSearchResultsController = true
        searchController.hidesNavigationBarDuringPresentation = true
        
        return searchController
    }()
    
    private lazy var tableViewDataSource: ConfigurableTableViewDataSource = {
        ConfigurableTableViewDataSource()
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
//        refreshControl.isEnabled = false
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(cellType: AssetTableViewCell.self)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: View Input

extension AssetsViewController: AssetsViewInputProtocol {
    
    func setTitle(text: String?) {
        navigationItem.title = text
    }
    
    func reloadTableView(with collection: ConfigurableCollectionProtocol) {
        tableViewDataSource.update(collection: collection)
        tableView.reloadData()
    }
    
    func reloadSearchTableView(with collection: ConfigurableCollectionProtocol) {
        searchResultsViewController.reloadTableView(with: collection)
    }
}

// MARK: UISearchBar delegate

extension AssetsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.didSearchTextChanged(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter?.didTapSearchButton()
    }
}

// MARK: UITableView delegate

extension AssetsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        guard let model = tableViewDataSource.collection?[indexPath] else {
            return
        }
        
        presenter?.didSelectTableRow(model)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cellsCount = tableViewDataSource.collection?.numberOfItems(in: 0),
              cellsCount < indexPath.row + 3 else {
            return
        }
        presenter?.didScrollToBottom()
    }
}
