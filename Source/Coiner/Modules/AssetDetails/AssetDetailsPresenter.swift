//
//  AssetDetailsPresenter.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Combine

final class AssetDetailsPresenter {
    
    enum CellId: Int {
        
        case marketCap
        case supply
        case volume
    }
    
    private weak var view: AssetDetailsViewInputProtocol?
    private let interactor: AssetDetailsInteractorInputProtocol?
    private let router: AssetDetailsRouterProtocol
    
    private let tableCollection: ConfigurableCollection
    
    private lazy var cellModels: [SimpleTableViewCellModel] = {
        [
            SimpleTableViewCellModel(
                id: CellId.marketCap.rawValue,
                text: loc("MarketCap")),
            SimpleTableViewCellModel(
                id: CellId.supply.rawValue,
                text: loc("Supply")),
            SimpleTableViewCellModel(
                id: CellId.volume.rawValue,
                text: loc("Volume24h"))
        ]
    }()
    
    private var isAssetInWatchlist: Bool = false
    var asset: AssetEntity?
    
    init(view: AssetDetailsViewInputProtocol,
         interactor: AssetDetailsInteractorInputProtocol?,
         router: AssetDetailsRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.tableCollection = ConfigurableCollection()
    }
    
    // MARK: Private methods
    
    private func updateCellsInfo(_ asset: AssetEntity) {
        cellModels.first(where: { $0.id == CellId.marketCap.rawValue })?.detailsText = asset.marketCap?.amountFormat("$", maxFractionDigits: 0)
        cellModels.first(where: { $0.id == CellId.supply.rawValue })?.detailsText = asset.supply?.amountFormat("$", maxFractionDigits: 0)
        cellModels.first(where: { $0.id == CellId.volume.rawValue })?.detailsText = asset.volume24Hr?.amountFormat("$", maxFractionDigits: 0)
    }
    
    private func fillDetails(_ asset: AssetEntity) {
        guard let interactor = interactor else {
            return
        }
        
        isAssetInWatchlist = interactor.isInWatchlist(asset: asset)
        
        view?.setTitle(text: asset.name, details: asset.symbol)
        view?.setFavouriteButton(filled: isAssetInWatchlist)
        let price = asset.price ?? 0
        let priceText = price < 0.1 ? price.amountFormat("$", minFractionDigits: 0, maxFractionDigits: 8) : price.amountFormat("$")
        view?.setHeader(text: priceText)
        view?.setSubheader(text: asset.changePercentage?.percentFormat(), isPositive: asset.changePercentage ?? -1 > 0)
        
        updateCellsInfo(asset)
        tableCollection.update(with: cellModels)
        view?.reloadTableView(with: tableCollection)
    }
}

// MARK: View output

extension AssetDetailsPresenter: AssetDetailsViewOutputProtocol {
    
    func viewDidLoad() {
        guard let asset = asset else {
            return
        }
        
        // Fill cells & another field in view from model
        fillDetails(asset)
        // Fetch data for update info and refill view
        interactor?.fetchAssetDetails(with: asset.id)
        // Fetch history for graphic
        interactor?.fetchAssetHistory(with: asset.id)
    }
    
    func didTapFavouriteButton() {
        guard let asset = asset else {
            return
        }
        
        if isAssetInWatchlist {
            interactor?.removeFromWatchlist(asset: asset)
        } else {
            interactor?.addToWatchlist(asset: asset)
        }
    }
}

// MARK: Interactor output

extension AssetDetailsPresenter: AssetDetailsInteractorOutputProtocol {
    
    func onAssetAddToWatchlist(asset: AssetEntity) {
        guard asset.id == self.asset?.id else {
            return
        }
        isAssetInWatchlist = true
        view?.setFavouriteButton(filled: true)
    }
    
    func onAssetRemoveFromWatchlist(asset: AssetEntity) {
        guard asset.id == self.asset?.id else {
            return
        }
        isAssetInWatchlist = false
        view?.setFavouriteButton(filled: false)
    }
    
    func didFetchAssetHistory(items: [HistoryPointEntity]) {
        let points = items.map({ NSDecimalNumber(decimal: $0.price).floatValue })
        let minPrice = items.min(by: { $0.price > $1.price })?.price ?? 0
        let maxPrice = items.max(by: { $0.price > $1.price })?.price ?? 0
        
        let minPriceLabel = minPrice < 1.1 ? minPrice.amountFormat("$", minFractionDigits: 0, maxFractionDigits: 8) : minPrice.amountFormat("$")
        let maxPriceLabel = maxPrice < 1.1 ? maxPrice.amountFormat("$", minFractionDigits: 0, maxFractionDigits: 8) : maxPrice.amountFormat("$")
        
        DispatchQueue.main.async {
            self.view?.drawChart(points: points, minLabelText: minPriceLabel, maxLabelText: maxPriceLabel)
        }
    }
    
    func didFailedFetchAssetHistory(_ error: Error) {
        DispatchQueue.main.async {
            self.router.showAlert(title: loc("AlertError"), message: error.localizedDescription)
        }
    }
    
    func didFetchAssetDetails(item: AssetEntity) {
        DispatchQueue.main.async {
            self.fillDetails(item)
        }
    }
    
    func didFailedFetchAssetDetails(_ error: Error) {
        DispatchQueue.main.async {
            self.router.showAlert(title: loc("AlertError"), message: error.localizedDescription)
        }
    }
}
