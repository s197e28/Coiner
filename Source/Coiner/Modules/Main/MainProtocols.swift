//
//  MainProtocols.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/23/22.
//

import UIKit
import Combine

// MARK: Builder

protocol MainBuilderProtocol: AnyObject {
    
    func make() -> UIViewController
}

