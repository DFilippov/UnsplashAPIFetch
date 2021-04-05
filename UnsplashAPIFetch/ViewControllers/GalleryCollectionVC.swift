//
//  GalleryCollectionVC.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 03/03/2020.
//  Copyright © 2020 Dmitry Filippov. All rights reserved.
// 

import UIKit
import CoreData

class GalleryCollectionVC: UICollectionViewController {
    
    let persistenceManager = PersistenceManager()
    var useSections: Bool = false
    
    // TODO: - DELETE property imageURLs
    var items: [UnsplashItemEntity]?
    
    let galleryMainSection = 0
    
    let spacerBarItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    var mainTabBarBadgeDelegate: MainTabBarBadgeDelegate?
    
    lazy var deleteBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItems))
        button.isEnabled = false
        button.tintColor = .red
        return button
    }()
    
    lazy var selectAllBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(selectAllItems))
        return button
    }()
    
//    lazy var findDuplicatesBarButton: UIBarButtonItem = {
//        let button = UIBarButtonItem(title: "Find Duplicates", style: .plain, target: self, action: #selector(findImageURLDuplicates))
//        button.tintColor = .systemGreen
//        return button
//    }()
    
    lazy var indexPathsForAllItems = (0..<(persistenceManager.fetchedRC?.fetchedObjects?.count ?? 0) ).map {
        IndexPath(item: $0, section: galleryMainSection)
    }

    
    // MARK: - Methods
    @objc private func selectAllItems() {
        let numberOfSelectedItems: Int = collectionView.indexPathsForSelectedItems!.count
        let areAllSelected = numberOfSelectedItems == persistenceManager.fetchedRC?.fetchedObjects?.count
        
        if areAllSelected {

            let selectedIndexPaths = collectionView.indexPathsForSelectedItems
            selectedIndexPaths?.forEach {
                collectionView.deselectItem(at: $0, animated: true)
            }
            
            enableDeleteBarButton()
            buttonSelectAllTitleLogic()
            
        } else if numberOfSelectedItems < persistenceManager.fetchedRC?.fetchedObjects?.count ?? 0 {
            buttonSelectAllTitleLogic()
            
            indexPathsForAllItems.forEach { indexPath in
                DispatchQueue.main.async {
                    
                    self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
                    self.enableDeleteBarButton()
                    self.buttonSelectAllTitleLogic()
                }
            }
        }
    }
    
    private func buttonSelectAllTitleLogic() {
        if collectionView.indexPathsForSelectedItems!.count < persistenceManager.fetchedRC?.fetchedObjects?.count ?? 0 {
            selectAllBarButton.title = "Select All"
            selectAllBarButton.tintColor = .systemBlue
        } else {
            selectAllBarButton.title = "Deselect All"
            selectAllBarButton.tintColor = .magenta
        }
    }
    
    private func enableDeleteBarButton() {
        if isEditing {
            if collectionView.indexPathsForSelectedItems!.count > 0 {
                deleteBarButton.isEnabled = true
            } else {
                deleteBarButton.isEnabled = false
            }
        }
    }
    
    @objc private func deleteItems() {
        
        let selectedIndexPaths = collectionView.indexPathsForSelectedItems
        selectedIndexPaths?.forEach { indexPath in
            guard let item = persistenceManager.fetchedRC?.object(at: indexPath) else { return }
            persistenceManager.context.delete(item)
            persistenceManager.saveContext()
            persistenceManager.requestItems()
        }
        deleteBarButton.isEnabled = false
//        var indexes = selectedIndexPaths!.map { $0.item }
//        indexes.sort()
//        indexes.reverse()
//        indexes.forEach {
//            items?.remove(at: $0)
//        }
//        collectionView.deleteItems(at: selectedIndexPaths!)
    }
    
    fileprivate func setupCollectionView() {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            collectionView.backgroundColor = .lightGray
            let minInterItemSpace: CGFloat = 3.0
            layout.minimumInteritemSpacing = minInterItemSpace
            layout.minimumLineSpacing = minInterItemSpace
            let numberOfItemsInRow: CGFloat = 3.0
    //        let width = (view.frame.width - spacing * 2 - padding * 0.5) / 3
            let width = (view.frame.width - minInterItemSpace * ( numberOfItemsInRow - 1)) / numberOfItemsInRow
            layout.itemSize = CGSize(width: width, height: width * 1.5 )
        
        
        }
        
        private func setupEditButton() {
            if !collectionView.visibleCells.isEmpty {
                navigationItem.leftBarButtonItem = editButtonItem
            }
        }
        
//        private func getImageURLs() {
//            let defaultsManager = DefaultsManager()
//            imageURLs = defaultsManager.getImageURLs() ?? [URL]()
//        }
        
//        @objc private func findImageURLDuplicates() {
//            deleteBarButton.isEnabled = true
//
//            var array =  [URL]()
//
//            for (index, url) in imageURLs.enumerated() {
//                if !array.contains(url) {
//                    array.append(url)
//                } else if array.contains(url) {
//                    let indexPath = IndexPath(item: index, section: galleryMainSection)
//                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
//                }
//            }
//            if !array.isEmpty {
//                print(#line, #function, "IS EMPTY")
//                findDuplicatesBarButton.isEnabled = false
//                deleteBarButton.isEnabled = false
//            }
//        }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        self.collectionView!.register(GalleryImageCell.self, forCellWithReuseIdentifier: GalleryImageCell.cellId)
        setupCollectionView()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupEditButton()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        persistenceManager.requestItems()
        persistenceManager.fetchedRC?.delegate = self
                
        let mainTabBC = UIApplication.shared.getRootVCFromWindow() as? MainTabBarController
        mainTabBarBadgeDelegate = mainTabBC
        mainTabBC?.updateBadge(count: 0)
        
        // Opens on the bottom of collection
        let numberOfItems = collectionView.numberOfItems(inSection: galleryMainSection)
        let lastItemIndexPath = IndexPath(item: numberOfItems - 1, section: galleryMainSection)
        collectionView.scrollToItem(at: lastItemIndexPath, at: .bottom, animated: false)
        
        
//        getImageURLs()
//        let indexPath = IndexPath(item: imageURLs.count - 1, section: galleryMainSection)
//        DispatchQueue.main.async{
//            self.collectionView.insertItems(at: [indexPath])
//        }
        
//        let lastItemIndex = imageURLs.count - 1
//        let lastItemIndexPath = IndexPath(item: lastItemIndex, section: galleryMainSection)
//        collectionView.scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        collectionView.reloadData()
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        isEditing = false
    }
    
    deinit {
        print(#line, #function, self, "DEINITIALIZED")
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.allowsMultipleSelection = editing
        
        deleteBarButton.isEnabled = false
//        findDuplicatesBarButton.isEnabled = true
        
        navigationController?.setToolbarHidden(!editing, animated: true)
        
        navigationController?.setNavigationBarHidden(editing, animated: true)
        
        if editing {
            toolbarItems = [deleteBarButton, spacerBarItem, selectAllBarButton, spacerBarItem, editButtonItem].reversed()
            navigationController?.toolbar.barTintColor = .clear
//            navigationItem.rightBarButtonItems = [deleteBarButton, selectAllBarButton, findDuplicatesBarButton]
            
        } else {
            selectAllBarButton.tintColor = .blue
            
            toolbarItems = []
//            navigationItem.rightBarButtonItems = []
            
            if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
                selectedIndexPaths.forEach {
                    collectionView.deselectItem(at: $0, animated: true)
                }
            }
//            selectAllBarButton.title = "Select All"
            buttonSelectAllTitleLogic()
        }
        
        let indexPaths = self.collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = self.collectionView.cellForItem(at: indexPath) as! GalleryImageCell
            cell.isEditing = editing
            cell.setupCheckBadge(isChecked: !editing)
        }
  
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return useSections ?  (persistenceManager.fetchedRC?.sections?.count ?? 1) : 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if useSections {
            return persistenceManager.fetchedRC?.sections?[section].objects?.count ?? 0
        } else {
            return persistenceManager.fetchedRC?.fetchedObjects?.count ?? 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        setupEditButton()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryImageCell.cellId, for: indexPath) as? GalleryImageCell else {
            print("Could not dequeue cell")
            return GalleryImageCell()
        }
        cell.isEditing = isEditing
        
        let item = persistenceManager.fetchedRC?.object(at: indexPath)
        
        DispatchQueue.main.async {
            cell.setupImageView()
            cell.imageView.image = UIImage(data: item?.image ?? Data())
        }
        
        return cell
    }

//     MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditing {
            enableDeleteBarButton()
            buttonSelectAllTitleLogic()
        } else {
            let detailVC = DetailViewController()
            detailVC.modalPresentationStyle = .overFullScreen
            detailVC.addButton.isHidden = true
            
            detailVC.selectedIndexPathFromGallery = indexPath
            
            
            present(detailVC, animated: true, completion: nil)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        enableDeleteBarButton()
        buttonSelectAllTitleLogic()
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cells = collectionView.visibleCells as! [GalleryImageCell]
        cells.forEach {
            $0.badgeImageView.isHidden = !self.isEditing
        }
        
        //        cells.forEach { cell in
        //            DispatchQueue.main.async {
        //                cell.badgeImageView.isHidden = !self.isEditing
        //            }
        //        }
    }
 
    // Uncomment this method to specify if the specified item should be highlighted during tracking
//    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
//        print(#line, "SHOULD SHOW MENU FOR ITEM AT")
//        return true
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//        return true
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//
//    }

}


extension GalleryCollectionVC: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let someIndexPath = indexPath ?? ( newIndexPath ?? nil)
        guard let cellIndex = someIndexPath else { return }
        
        switch type {
        case .delete:
            DispatchQueue.main.async {
                self.collectionView.deleteItems(at: [cellIndex])
            }
        case .insert:
            DispatchQueue.main.async {
                self.collectionView.insertItems(at: [cellIndex])
            }
        case .update:
            DispatchQueue.main.async {
                self.collectionView.reloadItems(at: [cellIndex])
            }
        default:
            break
        }
    }
}
