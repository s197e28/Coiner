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
        refreshControl.addTarget(self, action: #selector(self.didRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)
        tableView.register(cellType: AssetTableViewCell.self)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.refreshControl = refreshControl
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
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func didRefresh(_ sender: AnyObject) {
        presenter?.didStartRefresh()
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
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

// MARK: UISearchBar delegate

extension AssetsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.didChangeSearchBarText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.didTapSearchBarCancelButton()
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
              cellsCount < indexPath.row + 2 else {
            return
        }
        presenter?.didScrollToBottom()
    }
}
