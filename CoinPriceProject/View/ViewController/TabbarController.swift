//
//  TabbarController.swift
//  CoinPriceProject
//
//  Created by goat on 2/4/26.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.tabBar.tintColor = .systemBlue
        self.tabBar.backgroundColor = .systemGray5
        addVC()
    }
    
    private func addVC() {
        let coinListVC = CoinListViewController()
        coinListVC.viewModel = CoinViewModel()
        
        let favListVC = FavoriteListViewController()
        favListVC.viewModel = FavoriteViewModel()
    
        
        let viewControllersWithTabInfo: [(UIViewController, String, String, Int)] = [
            (coinListVC, "CoinList", "house", 0),
            (favListVC, "Favorite", "list.bullet.rectangle.portrait", 1),
        ]
        
        let navControllers = viewControllersWithTabInfo.map { vc, title, imageName, tag -> UINavigationController in
            let nav = UINavigationController(rootViewController: vc)
            nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: tag)
            nav.navigationBar.isTranslucent = true
            return nav
        }
        self.viewControllers = navControllers
    }
}

