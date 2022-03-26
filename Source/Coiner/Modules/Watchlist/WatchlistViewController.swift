//
//  WatchlistViewController.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit

final class WatchlistViewController: UIViewController {
    
    var presenter: WatchlistViewOutputProtocol?
    
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
        if #available(iOS 13, *) { } else {
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        }
        return tableView
    }()
    
    private lazy var emptyView: TextEmptyView = {
        let view = TextEmptyView()
        view.titleLabel.text = loc("EmptyTitle", from: .watchlist)
        view.subtitleLabel.text = loc("EmptySubtitle", from: .watchlist)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.viewWillAppear()
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.refreshControl = refreshControl
        tableView.layoutIfNeeded()
    }
    
    @objc func didRefresh(_ sender: AnyObject) {
        presenter?.didStartRefresh()
    }
}

// MARK: View Input

extension WatchlistViewController: WatchlistViewInputProtocol {
    
    func setTitle(text: String?) {
        navigationItem.title = text
    }
    
    func reloadTableView(with collection: ConfigurableCollectionProtocol) {
        tableViewDataSource.update(collection: collection)
        tableView.reloadData()
    }
    
    func deleteTableRows(at indexPaths: [IndexPath], with collection: ConfigurableCollectionProtocol) {
        tableViewDataSource.update(collection: collection)
        tableView.deleteRows(at: indexPaths, with: .fade)
    }
    
    func reloadTableRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .none)
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func showEmptyView() {
        tableView.backgroundView = emptyView
        tableView.isScrollEnabled = false
    }
    
    func hideEmptyView() {
        tableView.backgroundView = nil
        tableView.isScrollEnabled = true
    }
}

// MARK: UITableView delegate

extension WatchlistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        guard let model = tableViewDataSource.collection?[indexPath] else {
            return
        }
        
        presenter?.didSelectTableRow(model)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive, title: loc("Remove")) { [weak self] (_, _, completionHandler) in
            completionHandler(true)
            self?.presenter?.didActionRemoveTableRow(at: indexPath)
        }
        removeAction.backgroundColor = SemanticColor.negativeTextColor
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}
