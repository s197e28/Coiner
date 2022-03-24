//
//  Collection+Extensions.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        
        indices.contains(index) ? self[index] : nil
    }
}
