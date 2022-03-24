//
//  Configurator+Services.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/23/22.
//

import Swinject

extension Configurator {
    
    final class ServicesAssembly: Assembly {
        
        func assemble(container: Container) {
            container.register(AppIconManagerProtocol.self) { _ -> AppIconManagerProtocol in AppIconManager() }.inObjectScope(.container)
            container.register(CoincapApiServiceProtocol.self) { _ -> CoincapApiServiceProtocol in CoincapApiService() }.inObjectScope(.container)
            container.register(AssetsManagerProtocol.self) { _ -> AssetsManagerProtocol in AssetsManager() }.inObjectScope(.container)
        }
    }
}
