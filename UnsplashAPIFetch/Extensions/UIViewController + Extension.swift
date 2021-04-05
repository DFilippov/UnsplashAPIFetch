//
//  UIViewController + Extension.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 22/11/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("Error: No initial viewController in \(name) storyboard")
        }
    }
}
