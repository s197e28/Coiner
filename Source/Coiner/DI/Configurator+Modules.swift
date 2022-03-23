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
        }
    }
}
