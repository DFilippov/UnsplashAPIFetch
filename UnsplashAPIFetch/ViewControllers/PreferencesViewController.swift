//
//  PreferencesViewController.swift
//  UnsplashAPIFetch
//
//  Created by Дмитрий Ф on 21/05/2020.
//  Copyright © 2020 Dmitry Filippov. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {
    
    lazy var clearImageGalleryInfoButton: UIButton = {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        let button = UIButton(frame: frame)
        
        button.center = view.center
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        button.setTitle("Clear image gallery", for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.addTarget(self, action: #selector(showClearAlert), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemIndigo
        setupClearButton()
    }
    private func setupClearButton() {
        view.addSubview(clearImageGalleryInfoButton)
        clearImageGalleryInfoButton.translatesAutoresizingMaskIntoConstraints = true
        NSLayoutConstraint.activate([
            clearImageGalleryInfoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearImageGalleryInfoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func showClearAlert() {
        let alertController = UIAlertController(title: "Warning!", message: "Are you sure you want to delete images from the gallery?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete Images", style: .destructive) { _ in
            self.clearImageGalleryInfo()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func clearImageGalleryInfo() {
        let defaultsManager = UserDefaults.init(suiteName: DefaultsManager.galleryThumbImageURLs)
        defaultsManager?.removeObject(forKey: DefaultsManager.galleryThumbImageURLs)
    }
}
