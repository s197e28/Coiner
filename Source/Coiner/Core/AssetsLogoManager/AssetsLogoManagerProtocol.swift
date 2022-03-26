//
//  AssetsLogoManagerProtocol.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/26/22.
//

import Foundation
import UIKit

/// Manager for fetching images of assets.
protocol AssetsLogoManagerProtocol {
    
    func fetch(assetSymbol: String, completion: @escaping (UIImage?) -> Void)
    
    func retrive(assetSymbol: String) -> UIImage?
}
