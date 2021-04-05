//
//  DetailViewController.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 18/01/2020.
//  Copyright © 2020 Dmitry Filippov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var imageLoader = ImageLoader()
    var item: UnsplashItem?

    lazy var persistenceManager = PersistenceManager()
    var selectedIndexPathFromGallery: IndexPath?

    var imageView = UIImageView()
    var scrollView: UIScrollView!
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addItemToGallery), for: .touchUpInside)
        return button
    }()

//    weak var mainTabBarBadgeDelegate: MainTabBarBadgeDelegate?
    var mainTabBarBadgeDelegate: MainTabBarBadgeDelegate!

//    MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setBlurBackground()
        
        setupScrollView()
        setupAddButton()
        
        scrollView.delegate = self
//        centerImageInScrollView()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        
        // TODO: Setup doubleTapGesture for zoom In & zoom Out
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
//        tapGesture.numberOfTapsRequired = 2
//        scrollView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        fetchItemFromGallery()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setZoomParameters(scrollView.bounds.size)
        centerImageInScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setBlurBackground()
    }
//  MARK: - Methods
    private func setupAddButton() {
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func addItemToGallery() {
        guard let item = item else {
            print(#line, #function, "No item in \(self)")
            return
        }
        item.image = imageView.image  // another source for image for saving it in data base
        
        persistenceManager.saveItem(item: item)

        let application = UIApplication.shared
        let mainTabBC = application.getRootVCFromWindow() as? MainTabBarController
        mainTabBarBadgeDelegate = mainTabBC
        mainTabBarBadgeDelegate.updateBadge(count: 1)
    }
    
    private func fetchItemFromGallery() {
        persistenceManager.requestItems()
        guard let indexPath = selectedIndexPathFromGallery else { return }
        let fetchedItem = persistenceManager.fetchedRC?.object(at: indexPath)
        guard let data = fetchedItem?.image else { return }
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: data)
            
            print(#line, #function, #file, data)
        }
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame: view.frame)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
//            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0.0),
//            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0.0)
        ])
        scrollView.addSubview(imageView)
        setupImageView()
        scrollView.addSubview(addButton)
        
        guard let image = imageView.image else {
            print(#line, #function, self, "NO image in imageView", imageView)
            return
        }
        scrollView.contentSize = image.size
    }
    
    func setZoomParameters(_ scrollViewSize: CGSize) {
        let imageSize = imageView.bounds.size
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 5.0
        scrollView.zoomScale = minScale
    }
    
    func centerImageInScrollView() {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = imageView.frame.size
        
        let horisontalSpace = imageSize.width < scrollViewSize.width ?
            (scrollViewSize.width - imageSize.width) / 2
            : 0
        let verticalSpace = imageSize.height < scrollViewSize.height ?
            (scrollViewSize.height - imageSize.height) / 2
            : 0
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalSpace,
            left: horisontalSpace,
            bottom: verticalSpace,
            right: horisontalSpace)
    }
    
//    private func showDuplicateAlert() {
//        let alertController = UIAlertController(title: "Duplicate Alert", message: "You have already got this image in your gallery", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//        alertController.addAction(okAction)
//        present(alertController, animated: true, completion: nil)
//    }
    
    private func setBlurBackground() {
        let blurEffectView = UIVisualEffectView()
        blurEffectView.frame = view.frame
        blurEffectView.alpha = 0.0
        blurEffectView.effect = UIBlurEffect(style: .dark)
//        view.addSubview(blurEffectView)
        view.insertSubview(blurEffectView, belowSubview: scrollView)    //
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        ])
        UIView.animate(withDuration: 0.3) {
            blurEffectView.alpha = 1.0
        }
    }
    
    func setupImageView() {
//        DispatchQueue.main.async {
            
//            self.imageView.center = self.imageView.superview!.center
//            self.imageView.center = self.view.center
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.backgroundColor = .clear
            self.imageView.layer.cornerRadius = 0.0
//        }

        if let item = item {
            let urlAtStart = URL(string: item.urls.thumb)!
            let urlBetterQuality = URL(string: item.urls.regular)!
            imageLoader.loadImage(for: imageView, urlAtStart: urlAtStart, urlBetterQuality: urlBetterQuality)
        } else {
            fetchItemFromGallery()
        }
        DispatchQueue.main.async {
            self.imageView.frame.size = self.imageView.image!.size
            self.imageView.layer.cornerRadius = 0.0
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)

    }
    
//    private func animateImage(view: UIView) {
//
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0.2,
//            usingSpringWithDamping: 0.55,
//            initialSpringVelocity: 0.5,
//            options: [.curveEaseOut],
//            animations: {
//                guard let superviewFrame = view.superview?.frame else {
//                    print ("View's superview is nil")
//                    return
//                }
////                view.frame = superviewFrame
//                view.frame.size = CGSize(width: superviewFrame.width, height: superviewFrame.height / 2)
////                view.frame.origin = CGPoint(x: superviewFrame.origin.x, y: superviewFrame.origin.y)
//                view.center = CGPoint(x: superviewFrame.midX, y: superviewFrame.midY)
//        },
//            completion: nil)
//    }
    
}

extension DetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
