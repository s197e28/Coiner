//
//  Configurator.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/23/22.
//

import Swinject

final class Configurator {
    
    static let sharedInstance = Configurator()
    
    private let container: Container
    private let assembler: Assembler
    
    public var resolver: Resolver {
        assembler.resolver
    }
    
    private init() {
        container = Container()
        assembler = Assembler(container: container)
        
        configure(assembler: assembler)
    }
    
    private func configure(assembler: Assembler) {
        
        assembler.apply(assembly: ServicesAssembly())
        assembler.apply(assembly: ModulesAssembly())
    }
}
