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
    private var isAllItemsFetched: Bool = false
    
    private var searchText: String?
    private var isSearchMode: Bool {
        searchText?.isEmpty == false
    }
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
    
    private func mapCellModel(_ item: AssetEntity) -> AssetTableViewCellModel {
        let cellModel = AssetTableViewCellModel(
            entity: item.id,
            symbolText: item.symbol,
            nameText: item.name,
            priceText: interactor?.formatPrice(item.price),
            changeText: interactor?.formatPercentage(item.changePercentage),
            isChangePositive: interactor?.isChangePositive(item.changePercentage))
        
        if let logoImage = interactor?.retriveLogo(for: item) {
            cellModel.image = logoImage
        } else {
            interactor?.fetchLogo(for: item)
        }
        
        return cellModel
    }
}

// MARK: View output

extension AssetsPresenter: AssetsViewOutputProtocol {
    
    func viewDidLoad() {
        view?.setTitle(text: loc("ModuleTitle", from: .assets))
        
        state = .loadingMore
        currentFetchingTask = interactor?.fetchAssets(skip: 0, take: fetchingCount)
        view?.changeRefresh(isOn: true)
    }
    
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol) {
        let items = isSearchMode ? fetchedSearchItems : fetchedItems
        guard let cellModel = model as? AssetTableViewCellModel,
              let entityId = cellModel.entity as? String,
              let asset = items.first(where: { $0.id == entityId }) else {
            return
        }
        
        router.openAssetDetailsModule(asset: asset)
    }
    
    func didStartRefresh() {
        guard state != .refreshing else {
            return
        }
        
        isAllItemsFetched = false
        currentFetchingTask?.cancel()
        currentFetchingTask = nil
        
        state = .refreshing
        
        currentFetchingTask = interactor?.fetchAssets(skip: 0, take: fetchingCount)
    }
    
    func didChangeSearchBarText(_ value: String?) {
        // When search text was changed, clear table, cancel task and fetch new data
        currentFetchingTask?.cancel()
        fetchedSearchItems.removeAll()
        searchTableCollection.removeAll()
        isAllItemsFetched = false
        searchText = value
        
        guard searchText?.isEmpty == false else {
            view?.changeRefresh(isOn: true)
            view?.reloadTableView(with: tableCollection)
            return
        }
        
        view?.changeRefresh(isOn: false)
        view?.reloadTableView(with: searchTableCollection)
        state = .loadingMore
        currentFetchingTask = interactor?.fetchAssets(search: value, skip: 0, take: fetchingCount)
    }
    
    func didTapSearchBarCancelButton() {
        // When search bar cancel button was tapped, clear table, cancel task and reload normal data
        currentFetchingTask?.cancel()
        fetchedSearchItems.removeAll()
        searchTableCollection.removeAll()
        isAllItemsFetched = false
        searchText = nil
        
        view?.changeRefresh(isOn: true)
        view?.reloadTableView(with: tableCollection)
    }
    
    func didScrollToBottom() {
        guard state == .normal, !isAllItemsFetched else {
            return
        }
        
        state = .loadingMore
        if isSearchMode {
            currentFetchingTask = interactor?.fetchAssets(search: searchText, skip: fetchedSearchItems.count, take: fetchingCount)
        } else {
            currentFetchingTask = interactor?.fetchAssets(skip: fetchedItems.count, take: fetchingCount)
        }
    }
}

// MARK: Interactor output

extension AssetsPresenter: AssetsInteractorOutputProtocol {
    
    private func didFetchSearchAssets(items: [AssetEntity]) {
        fetchedSearchItems.append(contentsOf: items)
        let cellModels = items.map { mapCellModel($0) }
        searchTableCollection.add(items: cellModels)
        isAllItemsFetched = items.count < fetchingCount
        DispatchQueue.main.async {
            self.view?.reloadTableView(with: self.searchTableCollection)
            self.state = .normal
        }
    }
    
    func didFetchAssets(items: [AssetEntity]) {
        if isSearchMode {
            didFetchSearchAssets(items: items)
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
        
        isAllItemsFetched = items.count < fetchingCount
        DispatchQueue.main.async {
            self.view?.reloadTableView(with: self.tableCollection)
            if oldState == .refreshing {
                self.view?.endRefreshing()
            }
            self.state = .normal
        }
    }
    
    func didFailFetchAssets(_ error: Error) {
        let oldState = state
        
        DispatchQueue.main.async {
            if oldState == .refreshing {
                self.view?.endRefreshing()
            }
            self.router.showAlert(title: loc("AlertError"), message: error.localizedDescription)
            self.state = .normal
        }
    }
    
    func didFetchLogo(asset: AssetEntity, image: UIImage) {
        let collection = isSearchMode ? searchTableCollection : tableCollection
        guard let sectionItems = collection.sections.first?.items as? [AssetTableViewCellModel],
              let cellModelIndex = sectionItems.firstIndex(where: { $0.entity as? String == asset.id }),
              let cellModel = sectionItems[safe: cellModelIndex] else {
            return
        }
        
        cellModel.image = image
        DispatchQueue.main.async {
            self.view?.reloadTableRows(at: [IndexPath(row: cellModelIndex, section: 0)])
        }
    }
}
