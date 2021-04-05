//
//  UIApplication + Extension.swift
//  UnsplashAPIFetch
//
//  Created by Дмитрий Ф on 10/05/2020.
//  Copyright © 2020 Dmitry Filippov. All rights reserved.
//

import UIKit

extension UIApplication {
    func getRootVCFromWindow<T: UIViewController>() -> T? {
        let connectedScenes = self.connectedScenes
        let activeScenes = connectedScenes.filter { $0.activationState == .foregroundActive }
        let windowScene = activeScenes.first as! UIWindowScene
        let windows = windowScene.windows
        let keyWindow = windows.filter { $0.isKeyWindow }.first
        
        if let rootVC = keyWindow?.rootViewController as? T {
            return rootVC
        } else {
            fatalError("Could not get Root ViewController")
        }
    }
}
