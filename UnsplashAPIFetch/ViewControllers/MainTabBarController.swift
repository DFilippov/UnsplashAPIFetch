//
//  MainTabBarController.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 22/11/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import UIKit

protocol MainTabBarBadgeDelegate {
    func updateBadge(count: Int)
}

class MainTabBarController: UITabBarController {
    
    
    //MARK: - Properties
    let searchVC: SearchVC = SearchVC.loadFromStoryboard()
    /*    let searchVC = SearchVC.loadFromStoryboard()  implicit Type leads to crash the app
     (because in extension is implemented reference to the generic type (T: UIViewController) T.self -
     so, if we don't point the type SearchVC (which is child to UIViewController)
     then it is considered to be UIViewContoller
    */
    
    let galleryVC = GalleryCollectionVC(collectionViewLayout: UICollectionViewFlowLayout())
    
    let preferencesVC = PreferencesViewController()

    var countBadge = 0 {
        didSet {
            guard let galleryTabBarItem = tabBar.items?.first(where: { (tabBarItem) -> Bool in
                return tabBarItem.title == "Gallery"
            }) else {
                print(#line, #function, "Could not get  tabBarItem with title - Gallery")
                return
            }
            if countBadge != 0 {
                DispatchQueue.main.async {
                    galleryTabBarItem.badgeValue = String(self.countBadge)
                    
                }
            } else {
                galleryTabBarItem.badgeValue = nil
            }
        }
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            createVC(rootViewController: searchVC, title: "Search", imageName: "magnifyingglass.circle.fill"),
            createVC(rootViewController: galleryVC, title: "Gallery", imageName: "rectangle.grid.3x2"),
            createVC(rootViewController: preferencesVC, title: "Preferences", imageName: "gear")
        ]

    }
    
    
    // MARK: - Methods

    private func createVC(rootViewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        var iconImage = UIImage()
        if let image = UIImage(named: imageName) {
            iconImage = image
        } else if let image = UIImage(systemName: imageName) {
            iconImage = image
        }
        navigationController.tabBarItem.image = iconImage

        navigationController.navigationBar.prefersLargeTitles = true
        rootViewController.title = title
        
        tabBar.tintColor = .systemTeal

        return navigationController
    }
    
    
    @objc func changeBadge(number: Int) {
        countBadge += 1
    }
    
}

extension MainTabBarController: MainTabBarBadgeDelegate {
    func updateBadge(count: Int) {
        if count != 0 {
            self.countBadge += count
            
        } else {
            self.countBadge = 0
        }
        
    }
}
