//
//  AssetsLogoManager.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/26/22.
//

import Foundation
import UIKit

final class AssetsLogoManager: AssetsLogoManagerProtocol {
    
    private let fileManager = FileManager.default
    
    func fetch(assetSymbol: String, completion: @escaping (UIImage?) -> Void) {
        guard let fileUrl = tryGetFileUrl(assetSymbol),
              let iconUrl = URL(string: "https://raw.githubusercontent.com/alexandrebouttier/coinmarketcap-icons-cryptos/main/icons/\(assetSymbol.lowercased()).png") else {
            completion(nil)
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            guard let data = try? Data(contentsOf: iconUrl),
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            try? data.write(to: fileUrl)
            completion(image)
        }
    }
    
    func retrive(assetSymbol: String) -> UIImage? {
        guard let fileUrl = tryGetFileUrl(assetSymbol) else {
            return nil
        }
        
        guard fileManager.fileExists(atPath: fileUrl.path),
              let data = try? Data(contentsOf: fileUrl),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
    
    // MARK: Private methods
    private func tryGetFileUrl(_ name: String) -> URL? {
        try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("\(name.lowercased()).png")
    }
}
