//
//  SettingsPresenter.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import UIKit
import Combine

final class SettingsPresenter {
    
    enum CellId: Int {
        case changeIcon
    }
    
    private weak var view: SettingsViewInputProtocol?
    private let interactor: SettingsInteractorInputProtocol?
    private let router: SettingsRouterProtocol
    
    private let tableCollection: ConfigurableCollection
    private lazy var cellModels: [SimpleTableViewCellModel] = {
        [SimpleTableViewCellModel(
            id: CellId.changeIcon.rawValue,
            text: loc("ModuleTitle", from: .сhangeIcon),
            detailsText: interactor?.currentIcon.localizedName,
            accessoryType: .disclosureIndicator)]
    }()
    
    init(view: SettingsViewInputProtocol,
         interactor: SettingsInteractorInputProtocol?,
         router: SettingsRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.tableCollection = ConfigurableCollection()
    }
}

// MARK: View output

extension SettingsPresenter: SettingsViewOutputProtocol {
    
    func viewDidLoad() {
        view?.setTitle(text: loc("ModuleTitle", from: .settings))
        
        tableCollection.add(items: cellModels)
        view?.reloadTableView(with: tableCollection)
    }
    
    func didSelectTableRow(_ model: ConfigurableCellModelProtocol) {
        if model.id == CellId.changeIcon.rawValue {
            router.openChangeIconModule(output: self)
        }
    }
}

// MARK: Interactor output

extension SettingsPresenter: SettingsInteractorOutputProtocol {
    
}

// MARK: ChangeIconOutputProtocol

extension SettingsPresenter: ChangeIconOutputProtocol {
    
    func changeIconDidSuccess(_ icon: AppIcon) {
        guard let changeIconCellModel = cellModels.first(where: { $0.id == CellId.changeIcon.rawValue }) else {
            return
        }
        
        changeIconCellModel.detailsText = icon.localizedName
        view?.reloadTableView(with: tableCollection)
    }
}
