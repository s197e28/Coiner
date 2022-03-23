//
//  MainViewController.swift
//  Coiner
//
//  Created by Nikita Morozov on 3/23/22.
//

import UIKit

final class MainViewController: UITabBarController {
    
    var presenter: MainViewOutputProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        
    }
}

// MARK: View Input

extension MainViewController: MainViewInputProtocol {
    
}
