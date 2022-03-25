//
//  WatchlistPresenter.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Combine

final class WatchlistPresenter {
    
    private weak var view: WatchlistViewInputProtocol?
    private let interactor: WatchlistInteractorInputProtocol?
    private let router: WatchlistRouterProtocol
    
    private let tableCollection: ConfigurableCollection
    
    private var isRefresing: Bool = false
    private var items: [AssetEntity] = []
    
    init(view: WatchlistViewInputProtocol,
         interactor: WatchlistInteractorInputProtocol?,
         router: WatchlistRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.tableCollection = ConfigurableCollection()
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
    
    private func updateCellModels(_ items: [AssetEntity]) {
        let cellModels = items.map { mapCellModel($0) }
        tableCollection.update(with: cellModels)
        view?.reloadTableView(with: tableCollection)
    }
    
    private func refreshAssets() {
        isRefresing = true
        let ids = items.map({ $0.id })
        interactor?.fetchAssets(ids: ids)
    }
}

// MARK: View output

extension WatchlistPresenter: WatchlistViewOutputProtocol {
    
    func viewDidLoad() {
        view?.setTitle(text: loc("ModuleTitle", from: .watchlist))
        
        guard let items = interactor?.getWatchedAssets() else {
            return
        }
        self.items = items
        updateCellModels(items)
    }
    
    func viewWillAppear() {
        guard !isRefresing else {
            return
        }
        
        refreshAssets()
    }
    
    func didStartRefresh() {
        guard !isRefresing else {
            return
        }
        
        refreshAssets()
    }
    
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol) {
        guard let cellModel = model as? AssetTableViewCellModel,
              let entityId = cellModel.entity as? String,
              let asset = items.first(where: { $0.id == entityId }) else {
            return
        }
        
        router.openAssetDetailsModule(asset: asset)
    }
    
    func didActionRemoveTableRow(at indexPath: IndexPath) {
        guard let cellModel = tableCollection[indexPath] as? AssetTableViewCellModel,
              let entityId = cellModel.entity as? String,
              let item = items.first(where: { $0.id == entityId }) else {
            return
        }
        
        if let section = tableCollection.sections[safe: indexPath.section],
           section.items.count > indexPath.row {
            _ = section.remove(at: indexPath.row)
            view?.deleteTableRows(at: [indexPath], with: tableCollection)
        }
        
        interactor?.removeFromWatchlist(asset: item)
    }
}

// MARK: Interactor output

extension WatchlistPresenter: WatchlistInteractorOutputProtocol {
    
    func onAssetAddToWatchlist(asset: AssetEntity) {
        items.append(asset)
        updateCellModels(items)
    }
    
    func onAssetRemoveFromWatchlist(asset: AssetEntity) {
        items.removeAll(where: { $0.id == asset.id })
        updateCellModels(items)
    }
    
    func didFetchAssets(items: [AssetEntity]) {
        guard let sectionItems = tableCollection.sections.first?.items as? [AssetTableViewCellModel] else {
            return
        }
        
        var indexesForUpdate: [IndexPath] = []
        
        for item in items {
            guard let itemIndex = self.items.firstIndex(where: { $0.id == item.id }),
                  let cellModelIndex = sectionItems.firstIndex(where: { $0.entity as? String == item.id }),
                  let cellModel = sectionItems[safe: cellModelIndex] else {
                      continue
                  }
            
            self.items[itemIndex] = item
            indexesForUpdate.append(IndexPath(row: cellModelIndex, section: 0))
            
            cellModel.priceText = interactor?.formatPrice(item.price)
            cellModel.changeText = interactor?.formatPercentage(item.changePercentage)
            cellModel.isChangePositive = interactor?.isChangePositive(item.changePercentage)
            if cellModel.image == nil {
                interactor?.fetchLogo(for: item)
            }
        }
        
        DispatchQueue.main.async {
            self.view?.reloadTableRows(at: indexesForUpdate)
            self.view?.endRefreshing()
            self.isRefresing = false
        }
    }
    
    func didFailFetchAssets(_ error: Error) {
        DispatchQueue.main.async {
            self.router.showAlert(title: loc("AlertError"), message: error.localizedDescription)
            self.view?.endRefreshing()
            self.isRefresing = false
        }
    }
    
    func didFetchLogo(asset: AssetEntity, image: UIImage) {
        guard let sectionItems = tableCollection.sections.first?.items as? [AssetTableViewCellModel],
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
