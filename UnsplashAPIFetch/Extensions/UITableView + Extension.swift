//
//  UITableView + Extension.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 06/12/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import UIKit

extension UITableView {
    
    open func dequeueReusableCell<T: UITableViewCell>() -> T {
        
        let identifier = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? T else {
        
            print ("Couldn't get reusableCell as \(identifier)")
            return T()
        }
        return cell
    }
}
