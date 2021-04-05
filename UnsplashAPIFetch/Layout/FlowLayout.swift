//
//  FlowLayout.swift
//  UnsplashAPIFetch
//
//  Created by Дмитрий Ф on 16/04/2020.
//  Copyright © 2020 Dmitry Filippov. All rights reserved.
//

import UIKit

class FlowLayout: UICollectionViewFlowLayout {
    
    var addedItem: IndexPath?
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath), addedItem == itemIndexPath else {
            return nil
        }
        
        attributes.center = CGPoint(x: collectionView!.frame.width - 23.5, y: -24.5)
        attributes.alpha = 1.0
        attributes.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
        
        return attributes
    }
}
