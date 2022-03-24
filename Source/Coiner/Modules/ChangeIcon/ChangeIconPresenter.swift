//
//  ChangeIconPresenter.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Combine

final class ChangeIconPresenter {
    
    private weak var view: ChangeIconViewInputProtocol?
    private let interactor: ChangeIconInteractorInputProtocol?
    private let router: ChangeIconRouterProtocol
    private weak var output: ChangeIconOutputProtocol?
    
    private let tableCollection: ConfigurableCollection
    private lazy var cellModels: [CheckableTableViewCellModel] = {
        makeCellModels()
    }()
    
    init(view: ChangeIconViewInputProtocol,
         interactor: ChangeIconInteractorInputProtocol?,
         router: ChangeIconRouterProtocol,
         output: ChangeIconOutputProtocol?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.output = output
        
        self.tableCollection = ConfigurableCollection()
    }
    
    // MARK: Private methods
    
    private func makeCellModels() -> [CheckableTableViewCellModel] {
        guard let interactor = interactor else {
            return []
        }
        
        let availableIcons = interactor.availableIcons
        let currentIcon = interactor.currentIcon
        
        return availableIcons.map { (icon) in
            CheckableTableViewCellModel(
                entity: icon,
                text: icon.localizedName,
                checked: icon == currentIcon)
        }
    }
}

// MARK: View output

extension ChangeIconPresenter: ChangeIconViewOutputProtocol {
    
    func viewDidLoad() {
        view?.setTitle(text: loc("ModuleTitle", from: .сhangeIcon))
        
        tableCollection.add(items: cellModels)
        view?.reloadTableView(with: tableCollection)
    }
    
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol) {
        guard let checkableCellModel = model as? CheckableTableViewCellModel,
              let appIcon = checkableCellModel.entity as? AppIcon else {
            return
        }
        
        interactor?.change(to: appIcon)
    }
}

// MARK: Interactor output

extension ChangeIconPresenter: ChangeIconInteractorOutputProtocol {
    
    func didChange(icon: AppIcon) {
        for cellModel in cellModels {
            cellModel.checked = cellModel.entity as? AppIcon == icon
        }
        view?.reloadTableView(with: tableCollection)
        output?.changeIconDidSuccess(icon)
    }
    
    func didFailChange(_ error: Error) {
        router.showAlert(title: error.localizedDescription)
    }
}
