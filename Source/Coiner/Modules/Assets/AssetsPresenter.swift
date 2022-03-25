//
//  AssetsPresenter.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Combine

final class AssetsPresenter {
    
    private enum State {
        
        case normal
        case loadingMore
        case refreshing
    }
    
    private weak var view: AssetsViewInputProtocol?
    private let interactor: AssetsInteractorInputProtocol?
    private let router: AssetsRouterProtocol
    
    private let tableCollection: ConfigurableCollection
    private let searchTableCollection: ConfigurableCollection
    
    private let fetchingCount = 10
    private var state: State = .normal
    
    private var searchIsLoading: Bool = false
    
    private var searchMode: Bool {
        searchText?.isEmpty == false
    }
    private var searchText: String?
    
    private var currentFetchingTask: URLSessionTask?
    private var fetchedItems: [AssetEntity] = []
    private var fetchedSearchItems: [AssetEntity] = []
    
    init(view: AssetsViewInputProtocol,
         interactor: AssetsInteractorInputProtocol?,
         router: AssetsRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.tableCollection = ConfigurableCollection()
        self.searchTableCollection = ConfigurableCollection()
    }
    
    // MARK: Private methods
    
    private func fetchNextPage() {
        state = .loadingMore
        currentFetchingTask = interactor?.fetchAssets(skip: fetchedItems.count, take: fetchingCount)
    }
    
    private func mapCellModel(_ entity: AssetEntity) -> AssetTableViewCellModel {
        let price = entity.price ?? 0
        let priceText = price < 0.1 ? price.amountFormat("$", minFractionDigits: 0, maxFractionDigits: 8) : price.amountFormat("$")
        
        return AssetTableViewCellModel(
            entity: entity.id,
            symbolText: entity.symbol,
            nameText: entity.name,
            priceText: priceText,
            changeText: entity.changePercentage?.percentFormat(),
            isChangePositive: entity.changePercentage ?? -1 > 0)
    }
    
    private func didFetchSearchAssets(_ items: [AssetEntity]) {
        fetchedSearchItems.append(contentsOf: items)
        let cellModels = items.map { mapCellModel($0) }
        searchTableCollection.add(items: cellModels)
        
        DispatchQueue.main.async {
            self.view?.reloadSearchTableView(with: self.searchTableCollection)
            self.searchIsLoading = false
        }
    }
    
    private func didFailFetchSearchAssets(_ error: Error) {
        DispatchQueue.main.async {
            self.router.showAlert(title: loc("AlertError"), message: error.localizedDescription)
            self.searchIsLoading = false
        }
    }
}

// MARK: View output

extension AssetsPresenter: AssetsViewOutputProtocol {
    
    func viewDidLoad() {
        view?.setTitle(text: loc("ModuleTitle", from: .assets))
        
        fetchNextPage()
    }
    
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol) {
        guard let cellModel = model as? AssetTableViewCellModel,
              let entityId = cellModel.entity as? String,
              let asset = fetchedItems.first(where: { $0.id == entityId }) else {
            return
        }
        
        router.openAssetDetailsModule(asset: asset)
    }
    
    func didStartRefresh() {
        guard state != .refreshing else {
            return
        }
        
        currentFetchingTask?.cancel()
        currentFetchingTask = nil
        
        state = .refreshing
        
        currentFetchingTask = interactor?.fetchAssets(skip: 0, take: fetchingCount)
    }
    
    func didChangeSearchBarText(_ value: String?) {
        searchText = value
        
        fetchedSearchItems.removeAll()
        searchTableCollection.removeAll()
        view?.reloadSearchTableView(with: searchTableCollection)
        
        guard value?.isEmpty == false else {
            return
        }
        
        currentFetchingTask = interactor?.fetchAssets(search: value, skip: 0, take: fetchingCount)
    }
    
    func didTapSearchBarCancelButton() {
//        currentFetchingTask?.cancel()
//        currentFetchingTask = nil
//        searchText = nil
    }
    
    func didScrollToBottom() {
        guard state == .normal else {
            return
        }
        
//        fetchNextPage()
    }
}

// MARK: Interactor output

extension AssetsPresenter: AssetsInteractorOutputProtocol {
    
    func didFetchAssets(items: [AssetEntity]) {
        guard !searchMode else {
            didFetchSearchAssets(items)
            return
        }
        
        let oldState = state
        if oldState == .refreshing {
            fetchedItems.removeAll()
        }
        fetchedItems.append(contentsOf: items)
        let cellModels = items.map { mapCellModel($0) }
        if oldState == .refreshing {
            tableCollection.update(with: cellModels)
        } else {
            tableCollection.add(items: cellModels)
        }
        
        DispatchQueue.main.async {
            self.view?.reloadTableView(with: self.tableCollection)
            if oldState == .refreshing {
                self.view?.endRefreshing()
            }
            self.state = .normal
        }
    }
    
    func didFailFetchAssets(_ error: Error) {
        guard !searchMode else {
            didFailFetchSearchAssets(error)
            return
        }
        
        let oldState = state
        
        DispatchQueue.main.async {
            if oldState == .refreshing {
                self.view?.endRefreshing()
            }
            self.router.showAlert(title: loc("AlertError"), message: error.localizedDescription)
            self.state = .normal
        }
    }
}
