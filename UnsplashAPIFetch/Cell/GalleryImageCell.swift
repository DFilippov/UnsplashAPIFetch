//
//  GalleryImageCell.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 03/03/2020.
//  Copyright © 2020 Dmitry Filippov. All rights reserved.
//

import UIKit

class GalleryImageCell: UICollectionViewCell {
    
    static var cellId = "GalleryImageCell"
    
    let imageView = UIImageView()
    
    let imageLoader = ImageLoader()
    
    let badgeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "square"))
        imageView.frame.size = CGSize(width: 60, height: 60)
        imageView.isHidden = true
        return imageView
    }()
    
    var isEditing: Bool =  false {
        didSet {
            DispatchQueue.main.async {
                
                self.badgeImageView.isHidden = !self.isEditing
//                if self.isEditing {
//                    self.setupCheckBadge(isChecked: !self.isEditing)
//                }
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                DispatchQueue.main.async {
                    self.setupCheckBadge(isChecked: self.isSelected)
                }
            }
        }
    }

    func setupImageView(url: URL? = nil) {
        
        let superViewFrame = self.contentView.frame
        self.imageView.frame =  superViewFrame
        self.imageView.layer.cornerRadius = 10
        self.imageView.clipsToBounds = true
        self.contentView.addSubview(self.imageView)
        guard let url = url else { return }
        self.imageLoader.loadImage(for: self.imageView, urlAtStart: url, urlBetterQuality: nil)
        
    }
       
    func setupCheckBadge(isChecked: Bool) {
        
//        let name = isChecked ? "checkmark.circle" : "circle"
        let name = isChecked ? "checkmark.square.fill" : "square"
        badgeImageView.tintColor = .red
//        badgeImageView.tintAdjustmentMode = .automatic
        self.contentView.addSubview(self.badgeImageView)
        self.badgeImageView.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async {
            let badgeImage = UIImage(systemName: name)
            self.badgeImageView.image = badgeImage
//            let size = CGSize(width: badgeImage!.size.width * 2, height: badgeImage!.size.height * 2)
            
//            self.badgeImageView.sizeThatFits(CGSize(width: badgeImage!.size.width * 2, height: badgeImage!.size.height * 2))
            
//            let xPoint = self.contentView.frame.width / 2.0
//            let yPoint = self.contentView.frame.height / 2.0
//
//            self.badgeImageView.center = CGPoint(x: xPoint, y: yPoint)
//
//            let badgeImageViewWidth = self.badgeImageView.frame.width
//            let badgeImageViewHeight = self.badgeImageView.frame.height
            
            self.badgeImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5.0).isActive = true
            self.badgeImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5.0).isActive = true
        }
        
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0.5,
//            usingSpringWithDamping: 0.5,
//            initialSpringVelocity: 0.5,
//            options: [.transitionCurlDown],
//            animations: {
//                let trailingConstant: CGFloat = 15.0
//                let bottomConstant: CGFloat = 5.0
//
//                let badgeImageViewTrailingAnchor = self.badgeImageView.constraints.first { $0.firstAnchor == self.badgeImageView.trailingAnchor }
//                badgeImageViewTrailingAnchor?.constant = trailingConstant
//
//                let badgeImageViewBottomAnchor = self.badgeImageView.constraints.first { $0.firstAnchor == self.badgeImageView.bottomAnchor }
//                badgeImageViewBottomAnchor?.constant = bottomConstant
//        },
//            completion: nil)
    }
}
