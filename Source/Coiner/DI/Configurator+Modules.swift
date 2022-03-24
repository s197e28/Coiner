//
//  Configurator+Modules.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/23/22.
//

import Swinject

extension Configurator {
    
    final class ModulesAssembly: Assembly {
        
        func assemble(container: Container) {
            container.register(MainBuilderProtocol.self) { r -> MainBuilderProtocol in MainBuilder(resolver: r) }.inObjectScope(.container)
            container.register(AssetsBuilderProtocol.self) { r -> AssetsBuilderProtocol in AssetsBuilder(resolver: r) }.inObjectScope(.container)
            container.register(AssetDetailsBuilderProtocol.self) { r -> AssetDetailsBuilderProtocol in AssetDetailsBuilder(resolver: r) }.inObjectScope(.container)
            container.register(WatchlistBuilderProtocol.self) { r -> WatchlistBuilderProtocol in WatchlistBuilder(resolver: r) }.inObjectScope(.container)
            container.register(SettingsBuilderProtocol.self) { r -> SettingsBuilderProtocol in SettingsBuilder(resolver: r) }.inObjectScope(.container)
            container.register(ChangeIconBuilderProtocol.self) { r -> ChangeIconBuilderProtocol in ChangeIconBuilder(resolver: r) }.inObjectScope(.container)
        }
    }
}
