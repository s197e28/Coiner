//
//  WeakBox.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/24/22.
//

import Foundation

struct WeakBox<T> {
    
    private weak var anyValue: AnyObject?
    
    var value: T? {
        return anyValue as? T
    }
    
    init(_ value: T) {
        self.anyValue = value as AnyObject
    }
}
